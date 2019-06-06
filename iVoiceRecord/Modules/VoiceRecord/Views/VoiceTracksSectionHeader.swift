//
//  VoiceTracksSectionHeader.swift
//  iVoiceRecord
//
//  Created by Vlad Tkach on 6/6/19.
//  Copyright © 2019 Vlad Tkach. All rights reserved.
//

import Foundation
import UIKit


class VoiceTracksSectionHeader: UIView {
    static let standardHeight       : CGFloat = 40.0

    
    //MARK: Views
    var titleLabel: UILabel = UILabel()
    
    //MARK: Others
    var title: String = "" {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    //MARK: Initialization
    convenience init() {
        self.init(frame: CGRect.zero)
        
        prepareViews()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        preparePins()
    }
    
    //MARK: Preparing
    
    private func prepareViews() {
        backgroundColor = .lightGray
        
        //titleLabel
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.backgroundColor = .white
        titleLabel.numberOfLines = 1
        addSubview(titleLabel)
    }
    
    private func preparePins() {
        //titleLabel
        titleLabel.pin
            .start().marginStart(20)
            .top().marginTop(10)
            .end().marginEnd(20)
            .height(20)
    }
}
