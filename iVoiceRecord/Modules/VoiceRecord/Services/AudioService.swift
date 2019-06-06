//
//  AudioService.swift
//  iVoiceRecord
//
//  Created by Vlad Tkach on 6/4/19.
//  Copyright © 2019 Vlad Tkach. All rights reserved.
//

import Foundation
import RxSwift
import AVFoundation

enum VoiceRecordingStatus {
    case stoped
    case recording
}

enum VoicePlayingStatus {
    case stoped
    case playing
}


class AudioService: NSObject {

    //MARK: Main
    var session             : AVAudioSession?
    
    var audionRecorder      : AVAudioRecorder?
    var audioPlayer         : AVAudioPlayer?
    
    
    //MARK: Support
    var playingStatus               : Variable<VoicePlayingStatus>?
    var playingProgressVariable     : Variable<Float>?
    var playingProgress             : Progress?
    var playingProgressTimer        : Timer?

    
    var recordingStatus             : Variable<VoiceRecordingStatus> = Variable(.stoped)
    var recordingProgressVariable   : Variable<Float> = Variable(0.0)
    var recordingProgress           : Progress = Progress(totalUnitCount: voiceRecordingDuration)
    var recordingProgressTimer      : Timer?

    
    
    //MARK: Callback Closures
    var serviceCompleteRecordinFilePath: ((URL)->())?
    
    //MARK: Others
    var fileName = "audioFile.m4a"

    //MARK: Implementations
    override init() {
        super.init()
        
        prepareSession()
        prepareRecorder()
    }
    
    /* Sessions preparing */

    private func prepareSession() {
        session = AVAudioSession.sharedInstance()
        
        do {
            try session?.setCategory(.playAndRecord, mode: .default)
            try session?.setActive(true)

        } catch {
            // failed to record!
        }
    }
    
    /* Recorder preparing */
    private func getCacheDirectory() -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        return paths[0]
        
    }
    
    private func getFileURL() -> NSURL {
        let path  = getCacheDirectory().stringByAppendingPathComponent(path: fileName)
        let filePath = NSURL(fileURLWithPath: path)
        
        return filePath
    }
    
    private func prepareRecorder() {
        let settings: [String: Any] = [AVFormatIDKey: kAudioFormatAppleLossless,
                                       AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
                                       AVEncoderBitRateKey: 320000,
                                       AVNumberOfChannelsKey: 2,
                                       AVSampleRateKey: 44100.0 ]
        
        do {
            audionRecorder = try AVAudioRecorder(url: getFileURL() as URL, settings: settings)
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
        audionRecorder?.delegate = self
        audionRecorder?.prepareToRecord()
    }
    
    
    
    /* Player preparing */
    private func preparePlayer(url: URL) {
    
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
        
        audioPlayer?.delegate = self
        audioPlayer?.prepareToPlay()
        audioPlayer?.volume = 1.0
        
        audioPlayer?.play()
    }
    
    
    
    
    //MARK: Open logic
    
    func playVoiceTrack(withViewModel viewModel: VoiceTrackViewModel) {
        
        playingStatus = viewModel.playingStatus
        playingProgressVariable = viewModel.playingProgressVariable
        
        preparePlayer(url: viewModel.url)

        playingProgress = Progress(totalUnitCount: Int64(viewModel.duration*60))
        
        playingStatus?.value = .playing
        
        playingProgressTimer = Timer.scheduledTimer(withTimeInterval: 1/60.0, repeats: true) { [weak self] (timer) in
            guard let `self` = self else { return }
            
            
            guard self.playingProgress?.isFinished == false else {
                
                /* recording complete by timeout. */
                self.stopVoicePlaying()
                return
            }
            
            self.playingProgress?.completedUnitCount += 1
            self.playingProgressVariable?.value = Float(self.playingProgress?.fractionCompleted ?? 0.0)
        }
        
        /* need start playing ... */
        audioPlayer?.play()
    }
    
    func stopVoicePlaying() {
        playingStatus?.value = .stoped
        
        playingProgress?.completedUnitCount = 0
        playingProgressVariable?.value = Float(0.0)
        
        audioPlayer?.stop()
        playingProgressTimer?.invalidate()
    }
    
    func startVoiceRecordin() {
        
        recordingStatus.value = .recording
        
        recordingProgressTimer = Timer.scheduledTimer(withTimeInterval: 1/60.0, repeats: true) { [weak self] (timer) in
            guard let `self` = self else { return }
          
            
            guard self.recordingProgress.isFinished == false else {
               
                /* recording complete by timeout. */
                self.stopVoiceRecordin()
                return
            }
            
            self.recordingProgress.completedUnitCount += 1
            self.recordingProgressVariable.value = Float(self.recordingProgress.fractionCompleted)
        }
        
        /* need start record ... */
        audionRecorder?.record()
    }
    
    func stopVoiceRecordin() {
        recordingStatus.value = .stoped
        
        recordingProgress.completedUnitCount = 0
        recordingProgressVariable.value = Float(0.0)
        
        audionRecorder?.stop()
        recordingProgressTimer?.invalidate()
    }
}


//MARK: - Trimming Audio Logic
extension AudioService {

    func trimFileToPieces(numberOfPieces: Int,
                          fileUrl: URL,
                          destinationURls: [URL],
                          completion: @escaping ((Bool, String?)->()) ) {
        
        if numberOfPieces != destinationURls.count { print(":=-> ERROR with numberOfPieces and destinationURls count"); return }
        let asset = AVAsset(url: fileUrl)
        
        exportAsset(asset, destinationURLs: destinationURls, completion: { (isSuccess) in
            
            if isSuccess {
                completion(true, nil)
            } else {
                completion(false, "Will be some error!!!.")

            }
        })
    }
        
    
    func exportAsset(_ asset: AVAsset, destinationURLs: [URL], completion: ((Bool)->())? ) {


        /* 0. Calculate count of pieces and pieces file duration. */
        let numberOfPieces  = destinationURLs.count
        let duration        = CMTimeGetSeconds(asset.duration)
        let pieceDuration   = duration/Double(numberOfPieces)

        /* 1. Create DispatchGroup for processing all pieces. */
        let dispatchGroup = DispatchGroup()

        var successfullyProccessedCounter: Int = 0
        
        for i in 1...numberOfPieces {
            
            /* 2. Increment dispatchGroup process counter. */
            dispatchGroup.enter()

            /* 3. Process trimmed file to destination Url. */
            if let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) {

                
                /* 3.0  Prepare curret destination url and configure exporter. */
                let fileDestinationUrl = destinationURLs[i-1]

                exporter.outputFileType = AVFileType.m4a
                exporter.outputURL = fileDestinationUrl
                
                /* 3.1 Chose time range... */
                let startTime = CMTimeMake(value: Int64(pieceDuration*Double(i-1)), timescale: 1)
                let stopTime = CMTimeMake(value: Int64(pieceDuration*Double(i)), timescale: 1)
                exporter.timeRange = CMTimeRangeFromTimeToTime(start: startTime, end: stopTime)
                
                /* 3.2  exportAsynchronously. */
                exporter.exportAsynchronously(completionHandler: {
                    print("export complete \(exporter.status)")
                    
                    /* 3.3 handle proccess status. */
                    switch exporter.status {
                    case  AVAssetExportSessionStatus.failed:
                        
                        if let e = exporter.error {
                            print("export failed \(e)")
                        }
                        
                    case AVAssetExportSessionStatus.cancelled:
                        print("export cancelled \(String(describing: exporter.error))")
                    default:
                        successfullyProccessedCounter += 1
                        print("export complete")
                    }
                    
                    /* 3.4  dispatchGroup.leave. */
                    dispatchGroup.leave()
                })
            } else {
                print("cannot create AVAssetExportSession for asset \(asset)")
                /* 3.4  dispatchGroup.leave. */
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .global()) {
            /* 4. Handle 'All files processed'. */

            print(":=-> Prepared all pieces")
            if successfullyProccessedCounter == numberOfPieces {
                completion?(true)
            } else {
                completion?(false)
            }
            
        }
    }
}

//MARK: - AVAudioPlayerDelegate
extension AudioService: AVAudioPlayerDelegate {

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("audioPlayerDidFinishPlaying")
        
        stopVoicePlaying()
    }
}


//MARK: - AVAudioRecorderDelegate
extension AudioService: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        guard let fileUrl = getFileURL().filePathURL else { print(":=-> No file ulr after recordin"); return }
        
        serviceCompleteRecordinFilePath?(fileUrl)
    }
    
}
