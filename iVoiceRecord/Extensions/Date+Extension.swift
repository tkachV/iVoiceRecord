//
//  Date+Extension.swift
//  iVoiceRecord
//
//  Created by Vlad Tkach on 6/5/19.
//  Copyright © 2019 Vlad Tkach. All rights reserved.
//

import Foundation

extension Date {
    static func isoStringFrom(date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter.string(from: date)
    }
}
