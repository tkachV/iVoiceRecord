//
//  AppViewModel.swift
//  iVoiceRecord
//
//  Created by Vlad Tkach on 6/3/19.
//  Copyright © 2019 Vlad Tkach. All rights reserved.
//

import Foundation


class AppViewModel: NSObject {
    
    /* will be all view models */
    weak var voiceRecordViewModel: VoiceRecordViewModel?
    
    override init() {
        super.init()
        
        voiceRecordViewModel = generateVoiceRecordViewModel()
    }
    
    func generateVoiceRecordViewModel() -> VoiceRecordViewModel {
        
        /* Prepare HomeViewModel. Preparing services and others. */
        let homeViewModel = VoiceRecordViewModel()
        
        /* Configure voice record view Model. */
        self.voiceRecordViewModel = homeViewModel
        
        /* Return HomeViewModel*/
        return homeViewModel
    }
    
    
}
