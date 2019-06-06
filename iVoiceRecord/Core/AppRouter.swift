//
//  AppRouter.swift
//  iVoiceRecord
//
//  Created by Vlad Tkach on 6/3/19.
//  Copyright © 2019 Vlad Tkach. All rights reserved.
//

import Foundation



import Foundation
import UIKit

class AppRouter: NSObject {
    
    var window                      : UIWindow!
    
    //MARK: Controllers
    var rootNavigationController            : AppNavigationController!
    weak var currentNavigationController    : UINavigationController?
    
    //MARK: ViewModel
    var appViewModel: AppViewModel!
    
    //MARK: Implementations.
    init(window: UIWindow, viewModel: AppViewModel){
        super.init()
        
        self.window = window
        self.appViewModel = viewModel
        
        /* Show app navigation contrroler. */
        let appNavigationVC = AppNavigationController(viewModel: viewModel)
        rootNavigationController = appNavigationVC
        
        window.rootViewController = appNavigationVC
        window.makeKeyAndVisible()
    }
    
    //MARK: Workflows
    
    /* Home workflow. */
    
    func prepareVoiceRecordWorkflow(viewModel: VoiceRecordViewModel) {
        
        /* 2. Show home navigation view controller. */
        let homeNavigationController = VoiceRecordNavigationController(viewModel: viewModel)
        homeNavigationController.output = rootNavigationController

        self.currentNavigationController = homeNavigationController
        self.rootNavigationController.present(homeNavigationController, animated: true, completion: nil)
    }
}
