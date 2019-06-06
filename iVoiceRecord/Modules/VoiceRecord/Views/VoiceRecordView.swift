//
//  VoiceRecordView.swift
//  iVoiceRecord
//
//  Created by Vlad Tkach on 6/3/19.
//  Copyright © 2019 Vlad Tkach. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class VoiceRecordView: UIView {
    static let standardHeight = 70.0
    
    //MARK: Views
    var recordButton        : UIButton = UIButton()

    //MARK: Closures
    var recordActionClosure : (()->())?

    //MARK: Others
    var disposeBag = DisposeBag()
    
    //MARK: Initialization
    init(progressVariable: Variable<Float>, statusVariable: Variable<VoiceRecordingStatus>) {
        super.init(frame: CGRect.zero)
        
        prepareViews()
        prepareLayout()
        
        subscribeForProgress(variable: progressVariable, statusVariable: statusVariable)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    private func subscribeForProgress(variable: Variable<Float>, statusVariable: Variable<VoiceRecordingStatus>) {
       
        /* Bind progress value percent */
        variable.asObservable().observeOn(MainScheduler.instance).bind { [weak self] (progressValue) in
            guard let `self` = self else { return }
          
            /* Minimum track duration for 3.0s. */
            var seconds = progressValue * Float(VoiceTrackViewModel.maximumDurationTime)
            seconds = round(10.0 * seconds) / 10.0
            
            if seconds > 0.0 && seconds < 3.0 {
                self.recordButton.isEnabled = false
            } else if !self.recordButton.isEnabled {
                self.recordButton.isEnabled = true
            }
        }.disposed(by: disposeBag)
        
        /* Bind status */
        statusVariable.asObservable().observeOn(MainScheduler.instance).bind { [weak self] (status) in
            print("status - \(status)")
           
            switch status {
            case .recording:
                self?.recordButton.setTitle("Stop", for: .normal)

            case .stoped:
                self?.recordButton.setTitle("Record", for: .normal)
            }
        }.disposed(by: disposeBag)
        
    }
    
    //MARK: Preparing
    private func prepareViews() {
        
        backgroundColor = .white
        
        //recordButton
        recordButton.setTitle("Record", for: .normal)
        recordButton.backgroundColor = UIColor.black
        
        recordButton.rx.tap.bind { [weak self] () in
            self?.recordActionClosure?()
        }.disposed(by: disposeBag)
        
        addSubview(recordButton)
    }
    
    private func prepareLayout() {
        //recordButton
        recordButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(100)
        }
    }
    
}
