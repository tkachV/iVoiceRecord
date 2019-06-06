//
//  VoiceRecognitionNavigationController.swift
//  iVoiceRecord
//
//  Created by Vlad Tkach on 6/3/19.
//  Copyright © 2019 Vlad Tkach. All rights reserved.
//

import Foundation
import UIKit


enum VoiceRecordControllersType: String {
    case mainVoiceRecordController  = "MainVoiceRecordController"
}


protocol VoiceRecordNavigationOutput: class {
    

}

/// This is root navigation controller of auth module
class VoiceRecordController: UINavigationController {
    typealias Controller = UIViewController
    
    weak var output: VoiceRecognitionNavigationOutput?
    
    //MARK: ViewModel
    var viewModel: VoiceRecordViewModel?
    var currentControllerType: AuthControllersType!
    
    
    //MARK: - Core View Controllers

    
    //MARK: - Initialization
    init(viewModel: VoiceRecordViewModel) {
        let controller = UIStoryboard(name: Storyboards.Auth.rawValue,
                                      bundle: nil)
            .instantiateViewController(withIdentifier: AuthControllersType.authSplash.rawValue)
        
        super.init(rootViewController: controller)
        
        self.viewModel = viewModel
        (controller as? AuthSplashViewController)?.output = self
        (controller as? AuthSplashViewController)?.viewModel = viewModel
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - Implementations
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //    isNavigationBarHidden = true
        navigationBar.isTranslucent = true
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        
    }
}
