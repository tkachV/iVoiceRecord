//
//  BottomVoiceRecordView.swift
//  iVoiceRecord
//
//  Created by Vlad Tkach on 6/3/19.
//  Copyright © 2019 Vlad Tkach. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class BottomVoiceRecordView: UIView {
    
    //MARK: Views
    var recordButton        : UIButton = UIButton()
    var progressView        : UIProgressView = UIProgressView()
    

    //MARK: Others
    var disposeBag = DisposeBag()
    
    //MARK: Initialization
    init(progressVariable: Variable<Float>, statusVariable: Variable<Float>) {
        super.init(frame: CGRect.zero)
        
        prepareViews()
        prepareLayout()
        
        subscribeForProgress(variable: progressVariable, statusVariable: statusVariable)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func subscribeForProgress(variable: Variable<Float>, statusVariable: Variable<Float>) {
        variable.asObservable().subscribe(onNext: { (progress) in
            print("progress are = \(progress)")
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    //MARK: Preparing
    private func prepareViews() {
        //recordButton
//        recordButton.rx.tap
        //progressView
    }
    
    private func prepareLayout() {
        //recordButton
        //progressView
    }
    
}
