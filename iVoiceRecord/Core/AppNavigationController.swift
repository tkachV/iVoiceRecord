//
//  AppNavigationController.swift
//  iVoiceRecord
//
//  Created by Vlad Tkach on 6/3/19.
//  Copyright © 2019 Vlad Tkach. All rights reserved.
//

import Foundation
import UIKit



enum AppControllersType: String {
    case splash = "AppSplasViewController"
    
}

class AppNavigationController: UINavigationController {
    
    //MARK: ViewModel
    var viewModel: AppViewModel!
    
    //MARK: Initiation
    init(viewModel: AppViewModel) {
        let controller = UIStoryboard(name: Storyboards.Main.rawValue,
                                      bundle: nil)
            .instantiateViewController(withIdentifier: AppControllersType.splash.rawValue)
        
        super.init(rootViewController: controller)
        
        self.viewModel = viewModel
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: Implementation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isNavigationBarHidden = true
        
    }
    
}


extension AppNavigationController: VoiceRecordNavigationOutput {
    func compleVoiceRecordModuleWorkflow() {
        /* Logic for complete module workflow....*/
        
    }
    
    
}
