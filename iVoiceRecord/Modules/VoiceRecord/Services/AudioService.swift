//
//  VoiceRecordingService.swift
//  iVoiceRecord
//
//  Created by Vlad Tkach on 6/4/19.
//  Copyright © 2019 Vlad Tkach. All rights reserved.
//

import Foundation
import RxSwift

class VoiceRecordingService: NSObject {
    
    var progressVariable    : Variable<Float> = Variable(0.0)
    var progress            : Progress = Progress(totalUnitCount: voiceRecordingDuration)
    var progressTimer       : Timer?
    
    var status              : Variable<VoiceRecordingStataus> = Variable(.stoped)
    
    override init() {
        super.init()
        
    }
    
    func startVoiceRecording() {
        
        status.value = .recording
        
        Timer.scheduledTimer(withTimeInterval: 1/60.0, repeats: true) { [weak self] (timer) in
            
            guard self?.progress.isFinished == false else {
                /* recording complete by timeout. */
                
                return
            }
            
            self?.progress.completedUnitCount += 1
        }
        
        func stopVoiceRecognition() {
            status.value = .stoped
            
        }
    }
}
