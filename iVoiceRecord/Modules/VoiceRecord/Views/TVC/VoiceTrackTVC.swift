//
//  VoiceTrackTVC.swift
//  iVoiceRecord
//
//  Created by Vlad Tkach on 6/5/19.
//  Copyright © 2019 Vlad Tkach. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import PinLayout


enum VoiceTrackActionButtonStatusType {
    case play
    case stop
}

class VoiceTrackTVC: UITableViewCell {
    
    static let standardHeight       : CGFloat = 80.0
    
    //MARK: Views
    var titleLabel                  : UILabel = UILabel()
    var removeButton                : UIButton = UIButton()
    var actionButton                : UIButton = UIButton()
    var progressView                : UIProgressView = UIProgressView()
    var progressTimeStartLabel      : UILabel = UILabel()
    var progressTimeEndLabel        : UILabel = UILabel()
    
    //MARK: Models
    var viewModel           : VoiceTrackViewModel?
    var actionButtonStatus  : Variable<VoiceTrackActionButtonStatusType> = Variable(.stop)
    
    //MARK: Callback closures
    var mainActionClosure       : ((VoiceTrackViewModel)->())?
    var removeActionClosure     : ((VoiceTrackViewModel)->())?

    
    //MARK: Others
    var staticDisposeBag = DisposeBag()
    var disposeBag = DisposeBag()
    
    //MARK: Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        prapareViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        prapareViews()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        preparePins()
    }
    

    /* Fill with viewModel */
    func fill(withViewModel viewModel: VoiceTrackViewModel) {
        disposeBag = DisposeBag()
        
        self.viewModel = viewModel
        titleLabel.text = viewModel.trackName
        progressTimeEndLabel.text = "\(viewModel.duration)s."
        
        /* Bind progress value percent */
        viewModel.playingProgressVariable.asObservable().observeOn(MainScheduler.instance).bind { [weak self] (progressValue) in
            guard let `self` = self else { return }
            
            /* Minimum track duration for 3.0s. */
            var seconds = progressValue * Float(VoiceTrackViewModel.maximumDurationTime)
            seconds = round(10.0 * seconds) / 10.0

            
            self.progressView.setProgress(progressValue, animated: progressValue != 0.0 ? true : false)

        }.disposed(by: disposeBag)
        
        /* Bind status */
        viewModel.playingStatus.asObservable().observeOn(MainScheduler.instance).bind { [weak self] (status) in
            print("status - \(status)")
            
            switch status {
            case .playing:
                self?.actionButton.setTitle("Stop", for: .normal)
                
            case .stoped:
                self?.actionButton.setTitle("Play", for: .normal)
            }
        }.disposed(by: disposeBag)
    }
    
    //MARK: Preparing
    private func prapareViews() {
        
        selectionStyle = .none
        
        //titleLable
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.backgroundColor = .yellow
        titleLabel.numberOfLines = 2
        contentView.addSubview(titleLabel)
        
        //removeButton
        removeButton.backgroundColor = .red
        removeButton.setTitle("Remove", for: .normal)
        removeButton.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        removeButton.rx.tap.bind { [weak self] () in
            guard let viewModel = self?.viewModel else { return }

            print(":=-> Tap on remove button")
            self?.removeActionClosure?(viewModel)

        }.disposed(by: staticDisposeBag)

        contentView.addSubview(removeButton)

        //actionButton
        actionButton.setTitle("Play", for: .normal)
        actionButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)

        actionButton.backgroundColor = .green
        actionButton.rx.tap.bind { [weak self] () in
            guard let viewModel = self?.viewModel else { return }
           
            print(":=-> Tap on action button")
            self?.mainActionClosure?(viewModel)
            
        }.disposed(by: staticDisposeBag)
        
        contentView.addSubview(actionButton)

        //progressView
        progressView.progressTintColor = UIColor.red
        contentView.addSubview(progressView)
        
        
        //progressTimeStartLabel
        progressTimeStartLabel.text = "0.0"
        progressTimeStartLabel.textColor = .white
        progressTimeStartLabel.font = UIFont.systemFont(ofSize: 11)
        progressTimeStartLabel.backgroundColor = .gray
        contentView.addSubview(progressTimeStartLabel)

        
        //progressTimeEndLabel
        progressTimeEndLabel.text = "100.0"
        progressTimeEndLabel.textColor = .white
        progressTimeEndLabel.font = UIFont.systemFont(ofSize: 11)
        progressTimeEndLabel.backgroundColor = .gray
        progressTimeEndLabel.textAlignment = .right
        contentView.addSubview(progressTimeEndLabel)
    }
    
    private func preparePins() {
        //titleLabel
        titleLabel.pin
            .start().marginStart(20)
            .top().marginTop(10)
            .end().marginEnd(100)
            .height(32)
        
        //removeButton
        removeButton.pin
            .end().marginEnd(20)
            .top().marginTop(10)
            .height(15)
            .width(60)
        
        //actionButton
        actionButton.pin
            .end().marginEnd(20)
            .height(30)
            .width(60)
            .bottom().marginBottom(10)

        //progressView
        progressView.pin
            .start().marginStart(20)
            .vCenter(to: actionButton.edge.vCenter)
            .end(to: actionButton.edge.left).marginEnd(20)
        
        
        //progressTimeStartLabel
        progressTimeStartLabel.pin
            .start(to: progressView.edge.start)
            .top(to: progressView.edge.bottom).marginTop(5)
            .height(14)
            .sizeToFit(FitType.widthFlexible)
        
        
        //progressTimeEndLabel
        progressTimeEndLabel.pin
            .end(to: progressView.edge.end)
            .top(to: progressView.edge.bottom).marginTop(5)
            .height(14)
            .sizeToFit(FitType.widthFlexible)
    }
    

    //MARK: Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = ""
        progressTimeEndLabel.text = ""
        progressView.setProgress(0.0, animated: false)
    }
}
