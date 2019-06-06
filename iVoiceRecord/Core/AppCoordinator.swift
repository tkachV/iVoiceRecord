//
//  AppCoordinator.swift
//  iVoiceRecord
//
//  Created by Vlad Tkach on 6/3/19.
//  Copyright © 2019 Vlad Tkach. All rights reserved.
//

import Foundation
import UIKit


class AppCoordinator: NSObject {
    
    var router      : AppRouter!
    var viewModel   : AppViewModel!
    
    //Initializing
    init(window: UIWindow) {
        super.init()
        
        /* Some configuration.... */
        viewModel = AppViewModel()
        
        router = AppRouter(window: window, viewModel: viewModel)
    }
    
    /* MAIN workflow function. */
    func startApplicationWorkflow() {
        self.router.prepareVoiceRecordWorkflow(viewModel: viewModel.generateVoiceRecordViewModel())
    }
    
}
