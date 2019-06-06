//
//  String+Extension.swift
//  iVoiceRecord
//
//  Created by Vlad Tkach on 6/4/19.
//  Copyright © 2019 Vlad Tkach. All rights reserved.
//

import Foundation


extension String {
    func stringByAppendingPathComponent(path: String) -> String {
        let nsString = self as NSString
        return nsString.appendingPathComponent(path)
    }
}
