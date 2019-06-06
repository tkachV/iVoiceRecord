//
//  VoiceRecordNavigationController.swift
//  iVoiceRecord
//
//  Created by Vlad Tkach on 6/3/19.
//  Copyright © 2019 Vlad Tkach. All rights reserved.
//

import Foundation
import UIKit


enum VoiceRecordControllersType: String {
    case mainVoiceRecordController  = "MainVoiceRecordController"
    case trackDetailsController = "DetailsVoiceTrackController"
}


protocol VoiceRecordNavigationOutput: class {
    
    func compleVoiceRecordModuleWorkflow()
}

/// This is root navigation controller of auth module
class VoiceRecordNavigationController: UINavigationController {
    typealias Controller = UIViewController
    
    weak var output: VoiceRecordNavigationOutput?
    
    //MARK: ViewModel
    var viewModel: VoiceRecordViewModel?
    var currentControllerType: VoiceRecordControllersType!
    
    
    //MARK: Core View Controllers

    
    //MARK: Initialization
    init(viewModel: VoiceRecordViewModel) {
        let controller = UIStoryboard(name: Storyboards.VoiceRecord.rawValue,
                                      bundle: nil)
            .instantiateViewController(withIdentifier: VoiceRecordControllersType.mainVoiceRecordController.rawValue)
        
        super.init(rootViewController: controller)
        
        self.viewModel = viewModel
        (controller as? MainVoiceRecordController)?.output = self
        (controller as? MainVoiceRecordController)?.setViewModel(viewModel)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: Implementations
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

//MARK: - MainVoiceRecordOutput
extension VoiceRecordNavigationController: MainVoiceRecordOutput {
    func showDetails(forTrack viewModel: VoiceTrackViewModel) {
       
        let detailsVC = UIStoryboard(name: Storyboards.VoiceRecord.rawValue,
                                      bundle: nil)
            .instantiateViewController(withIdentifier: VoiceRecordControllersType.trackDetailsController.rawValue)
        
        
        (detailsVC as? DetailsVoiceTrackController)?.output = self
        (detailsVC as? DetailsVoiceTrackController)?.setViewModel(viewModel)
        
        self.pushViewController(detailsVC, animated: true)
    }
}

extension VoiceRecordNavigationController: DetailsVoiceTrackOutput {
    
}
