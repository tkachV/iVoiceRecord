//
//  LocalStorageService.swift
//  iVoiceRecord
//
//  Created by Vlad Tkach on 6/4/19.
//  Copyright © 2019 Vlad Tkach. All rights reserved.
//

import Foundation


class LocalStorageService: NSObject {
    let tracksDirectoryName             : String = "Voice Tracks"

    
    
    func removeDirectory(forUrl url: URL) {
        do {
            try FileManager.default.removeItem(at: url)

        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func removeVoiceTrack(forViewModel viewModel: VoiceTrackViewModel) {
        do {
            try FileManager.default.removeItem(at: viewModel.url)
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
        
    }
    
    
    /// Description
    ///
    /// - Returns: return value description
    func getSectionTupleFromLocalStorage() -> [(String, [VoiceTrackViewModel])] {
        
        let filemgr = FileManager.default
        
        var tuples: [(String, [VoiceTrackViewModel])] = []
        
        if let dir = getDirectoryForSaving(withName: tracksDirectoryName) {
            let directoryContents = try? filemgr.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil, options: [])

            for content in directoryContents ?? [] {
                let localDirectoryContent = try? filemgr.contentsOfDirectory(at: content, includingPropertiesForKeys: nil, options: [])
                
                let mainName: String = content.lastPathComponent
                var tracks: [VoiceTrackViewModel] = []
                
                localDirectoryContent?.forEach({ (url) in
                    tracks.append( VoiceTrackViewModel(trackUrl: url))
                })
                
                if tracks.count > 0 {
                    tuples.append((mainName, tracks))
                } else {
                    /* Support logic for removing empty directories. */
                    self.removeDirectory(forUrl: content)
                }
            }
        }
        return tuples
    }

    /// Description
    ///
    /// - Parameters:
    ///   - fileName: fileName description
    ///   - numberOfPieces: numberOfPieces description
    ///   - fileTypeString: fileTypeString description
    /// - Returns: return value description
    func prepareDistinationPiecesUrlsForFile(fileName: String,
                                             numberOfPieces: Int,
                                             fileTypeString: String) -> [URL]{
        
        /* 0. Get directory. */
        if let dir = getDirectoryForSaving(withName: tracksDirectoryName) {
            
            let directoryName = fileName
            let directoryURL = dir.appendingPathComponent(directoryName)
            let newDir = directoryURL.path
            let filemgr = FileManager.default
            
            /* 1. Create directory for current track. */
            do {
                try filemgr.createDirectory(atPath: newDir,
                                            withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
            }
            
            /* 2. Create destination URLs. */
            
            var urls: [URL] = []
        
            for i in 1...numberOfPieces {
                let destinationFileName = fileName + " piece #\(i)" + fileTypeString
                print(destinationFileName)
                let destinationUrl = directoryURL.appendingPathComponent(destinationFileName)
                
                urls.append(destinationUrl)
            }
           
            /* 3. Return destination urls. */
            return urls
        }
        
        return []
    }
}

// MARK: - Private  interface
extension LocalStorageService  {
    
    
    /// Description
    ///
    /// - Parameter name: name description
    /// - Returns: return value description
    internal func getDirectoryForSaving(withName name: String) -> URL? {
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        
        if let pathComponent = url.appendingPathComponent(name) {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            
            if fileManager.fileExists(atPath: filePath) {
                return pathComponent
            } else {
                let requestsLogsDirectoryPath = prepareAndGetDirectoryForSaving(withName: name)
                return requestsLogsDirectoryPath
            }
        } else {
            let requestsLogsDirectoryPath = prepareAndGetDirectoryForSaving(withName: name)
            return requestsLogsDirectoryPath
        }
    }
    
    
    /// Description
    ///
    /// - Parameter name: name description
    /// - Returns: return value description
    internal func prepareAndGetDirectoryForSaving(withName name: String) -> URL? {
        
        let filemgr = FileManager.default
        let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        let docsURL = dirPaths[0]
        let directoryURL = docsURL.appendingPathComponent(name)
        let newDir = directoryURL.path
        
        do {
            try filemgr.createDirectory(atPath: newDir,
                                        withIntermediateDirectories: true, attributes: nil)
            return directoryURL
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
        return nil
    }
}
