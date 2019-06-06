//
//  VoiceRecordViewModel.swift
//  iVoiceRecord
//
//  Created by Vlad Tkach on 6/3/19.
//  Copyright © 2019 Vlad Tkach. All rights reserved.
//

import Foundation
import RxSwift

let voiceRecordingDuration: Int64 = 30 * 60

class VoiceRecordViewModel: ViewModel {
    
    
    /* Core UI View Models */
    var sections            : Variable<[SectionModels]> = Variable([])
    
    var sectionsTuples      : Variable<[(String, [VoiceTrackViewModel])]> = Variable([])
    
    //var tracksViewModels    : Variable<[VoiceTrackViewModel]> = Variable([])
    

    /* Core SERVICES. */
    var audionService       : AudioService = AudioService()
    var storageService      : LocalStorageService = LocalStorageService()
    
    
    //MARK: Others
    var isServiceActiveNow: Bool {
        return !(audionService.playingStatus?.value == .stoped
            && audionService.recordingStatus.value == .stoped)
        
    }
    
    var disposeBag = DisposeBag()
    
    
    //MARK: Implementations
    override init() {
        super.init()
        
        bindTracksViewModels()
        prepareAudioServiceCallbackClosures()
        
        /* Load track from local storage. */
        sectionsTuples.value = storageService.getSectionTupleFromLocalStorage()
    }
    
    private func bindTracksViewModels() {
        sectionsTuples.asObservable().bind { [weak self] (tuples) in
            
            var sections: [SectionModels] = []
          
            tuples.forEach({ (tuple) in
                let headerVM = SimpleVoiceTracksSectionHeaderViewModel(title: tuple.0)
                let section = SectionModels.Section(headerVM: headerVM, items: tuple.1, key: "tracks_view_models_section_\(tuple.0)")
              
                sections.append(section)
            })
            
            self?.sections.value = sections
        }.disposed(by: disposeBag)
    }
    
    
    //MARK: - Service callback closures
    private func prepareAudioServiceCallbackClosures() {
        
        audionService.serviceCompleteRecordinFilePath = { [weak self] (fileUrl) in
            let fileName = Date.isoStringFrom(date: Date())
            print(":=-> VoiceRecordViewModel handle fileUrl: \(fileUrl)! ")
            
            /* 1. Need trimme file to 3 files. */
            let numberOfPieces: Int = 3
            let destinationURLs = self?.storageService.prepareDistinationPiecesUrlsForFile(fileName: fileName,
                                                                                           numberOfPieces: numberOfPieces,
                                                                                           fileTypeString: ".m4p") ?? []
            /* 2. Save 3 files */
            self?.audionService.trimFileToPieces(numberOfPieces: numberOfPieces, fileUrl: fileUrl, destinationURls: destinationURLs, completion: { [weak self] (isSuccess, errorString) in
                
                /* 3. Update Tracks viewModels + update sections. */

                var tracksViewModels: [VoiceTrackViewModel] = []

                if isSuccess {
                    destinationURLs.forEach({ (url) in
                        
                        let vm = VoiceTrackViewModel(trackUrl: url)
                        tracksViewModels.append(vm)
                    })
                }
                self?.sectionsTuples.value = (self?.sectionsTuples.value ?? []) + [(fileName, tracksViewModels)]
            })
        }
    }
    
    //MARK: - LocalStorage
    func removeFile(forViewModel viewModel: VoiceTrackViewModel) {
        
        storageService.removeVoiceTrack(forViewModel: viewModel)
        
        /* reload after removing. */
        sectionsTuples.value = storageService.getSectionTupleFromLocalStorage()
    }
    
    //MARK: - Recording
    func record() {
        if audionService.recordingStatus.value == .recording {
            audionService.stopVoiceRecordin()
        } else {
            audionService.startVoiceRecordin()
        }
    }
    
    
    //MARK: - Playing

    func playFile(forViewModel viewModel: VoiceTrackViewModel) {
        if audionService.playingStatus?.value == .playing {
            audionService.stopVoicePlaying()
        } else {
            audionService.playVoiceTrack(withViewModel: viewModel)
        }
    }

}
