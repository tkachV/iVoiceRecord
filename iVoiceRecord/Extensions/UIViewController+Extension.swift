//
//  UIViewControllerExtension.swift
//  iVoiceRecord
//
//  Created by Vlad Tkach on 6/4/19.
//  Copyright © 2019 Vlad Tkach. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension UIViewController {
  
    
    func canRecordVoiceByMicro(disposeBag: DisposeBag, completion: @escaping (Bool)->()) {
        let yesS                = "Yes"
        let cancelS             = "Cancel"
        let needAccessPhotoS    = "Need access to voice recording"
        let goToSettingsQuestion  = "Go to settings?"
        
        PermissionManager.stateRecordPermissionPermission
            .observeOn(MainScheduler.instance).bind { [weak self] (permissionState) in
         
            if permissionState == .granted {
                completion(true)
            } else if permissionState == .denied {
                let yes = UIAlertAction(title: yesS, style: .default, handler: { (alert) in
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        DispatchQueue.main.async {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            } else {
                                UIApplication.shared.openURL(url)
                            }
                        }
                    }
                })
                
                let no = UIAlertAction(title: cancelS, style: .cancel, handler: { (alert) in })
                let alertController = UIAlertController(title: needAccessPhotoS,
                                                        message: goToSettingsQuestion,
                                                        preferredStyle: .alert)
                alertController.addAction(yes)
                alertController.addAction(no)
                self?.present(alertController, animated: true, completion: {
                    completion(false)
                })
            }
        }.disposed(by: disposeBag)
        
    }
}
