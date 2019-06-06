//
//  DetailsVoiceTrackController.swift
//  iVoiceRecord
//
//  Created by Vlad Tkach on 6/6/19.
//  Copyright © 2019 Vlad Tkach. All rights reserved.
//

import Foundation
import UIKit

//MARK: - DetailsVoiceTrackOutput
protocol DetailsVoiceTrackOutput: class {
    
}

//MARK: - DetailsVoiceTrackInput
protocol DetailsVoiceTrackInput: class {
    func setViewModel(_ viewModel: VoiceTrackViewModel)
}

class DetailsVoiceTrackController: UIViewController, DetailsVoiceTrackInput {
    
    var output      : DetailsVoiceTrackOutput?

    
    var viewModel: VoiceTrackViewModel?
    
    
    
    
    
    
    
    
    
    
    //MARK: Input
    func setViewModel(_ viewModel: VoiceTrackViewModel) {
        self.viewModel = viewModel
        
    }
}
