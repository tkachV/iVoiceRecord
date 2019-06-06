//
//  VoiceTrackViewModel.swift
//  iVoiceRecord
//
//  Created by Vlad Tkach on 6/5/19.
//  Copyright © 2019 Vlad Tkach. All rights reserved.
//

import Foundation
import AVFoundation
import RxSwift


class VoiceTrackViewModel: ViewModel {
 
    static let maximumDurationTime = 30.0

    var url: URL
    
    
    var trackName   : String = "trackName"
    var duration    : Double = 0.0
    
    var playingStatus               : Variable<VoicePlayingStatus> = Variable(.stoped)
    var playingProgressVariable     : Variable<Float> = Variable(0.0)
    
    
    //MARK: Implementaions
    init(trackUrl: URL) {
        self.url = trackUrl

        super.init()
        
        
        let asset = AVAsset(url: trackUrl)
        
        let duration        = CMTimeGetSeconds(asset.duration)
        self.duration = round(100.0 * duration) / 100.0

        
        trackName       = trackUrl.lastPathComponent

    }
}
