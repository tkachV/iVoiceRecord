//
//  MainVoiceRecordStatusView.swift
//  iVoiceRecord
//
//  Created by Vlad Tkach on 6/6/19.
//  Copyright © 2019 Vlad Tkach. All rights reserved.
//

import Foundation
import UIKit
import RxSwift


class MainVoiceRecordStatusView: UIView {
    //MARK: Views
    var titleLabel                  : UILabel = UILabel()
    var progressView                : UIProgressView = UIProgressView()
    
    var progressTimeLabel           : UILabel = UILabel()
    
    
    //MARK: Closures
    var recordActionClosure: (()->())?
    
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
            print("progressValue - \(progressValue)")
         
            var seconds = progressValue * Float(VoiceTrackViewModel.maximumDurationTime)
            seconds = round(10.0 * seconds) / 10.0
            self?.progressTimeLabel.text = "\(seconds)s."
            self?.progressView.setProgress(progressValue, animated: true)

        }.disposed(by: disposeBag)
        
    }
    
    //MARK: Preparing
    private func prepareViews() {
        
        backgroundColor = .black
        
        //titleLabel
        titleLabel.text = "Recording..."
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 40)
        addSubview(titleLabel)

        //progressView
        progressView.progressTintColor = UIColor.red
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 5.0)
        addSubview(progressView)
        
        //progressTimeLabel
        progressTimeLabel.text = "0.0s."
        progressTimeLabel.textColor = .white
        progressTimeLabel.font = UIFont.boldSystemFont(ofSize: 40)
        progressTimeLabel.textAlignment = .center
        addSubview(progressTimeLabel)
    }
    
    private func prepareLayout() {

        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(progressView.snp.top).offset(-50)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
        }
        
        //progressView
        progressView.snp.makeConstraints { (make) in
            make.center.equalToSuperview().offset(-10)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
        }
        
        //progressView
        progressTimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.progressView.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
        }
        
    }
    
}
