//
//  PermissionsManager.swift
//  iVoiceRecord
//
//  Created by Vlad Tkach on 6/4/19.
//  Copyright © 2019 Vlad Tkach. All rights reserved.
//

import Foundation
import RxSwift
import AVFoundation


enum PermissionsState {
    case unknown
    case granted
    case denied
}

class PermissionManager: NSObject {
    static let shared = PermissionManager()
    
    private var currentRecordPermissionPermission: Variable<PermissionsState?> = Variable(nil)
}

//MARK: - Photo Library
extension PermissionManager {
    
    static var stateRecordPermissionPermission: Observable<PermissionsState> {
        return Observable.create { observer in
            DispatchQueue.main.async {

                if AVAudioSession.sharedInstance().recordPermission == AVAudioSession.RecordPermission.granted {
                    observer.onNext(.granted)
                    observer.onCompleted()
                } else {
                    AVAudioSession.sharedInstance().requestRecordPermission({ (newStatus) in
                        if newStatus {
                            observer.onNext(.granted)
                            observer.onCompleted()
                        } else {
                            observer.onNext(.denied)
                            observer.onCompleted()
                        }
                    })
                }
            }
            return Disposables.create()
        }
    }
}
