//
//  RxDataSource+Sections.swift
//  iVoiceRecord
//
//  Created by Vlad Tkach on 6/5/19.
//  Copyright © 2019 Vlad Tkach. All rights reserved.
//

import Foundation
import RxDataSources

enum SectionModels {
    case Section(headerVM: ViewModel?, items: [ViewModel], key: String)
}


/// This class need for RxDataSources.
class ViewModel: NSObject {
    var customIdentity: Int?
    var modelHash: Int {
        get {
            return customIdentity ?? self.hashValue
        }
    }
}


class CellViewModel: ViewModel {
    var customCellIdentifier: String?
    var cellIdentifier: String! {get {return "override"}}
    var cellClass: String! {get {return "override"}}
}

extension ViewModel: IdentifiableType {
    typealias Identity = Int
    
    var identity: Int {
        return self.modelHash
    }
}

// equatable, this is needed to detect changes
func == (lhs: ViewModel, rhs: ViewModel) -> Bool {
    return lhs.modelHash == rhs.modelHash
}

extension SectionModels: SectionModelType, AnimatableSectionModelType {
    
    var identity: String {
        switch self {
        case .Section(headerVM: _, items: _, key: let key):
            return key
        }
    }
    
    typealias Identity = String
    
    typealias Item = ViewModel
    
    var items: [ViewModel] {
        switch self {
        case .Section(headerVM: _, items: let items, key: _):
            return items.map {$0}
        }
    }
    
    init(original: SectionModels, items: [Item]) {
        switch original {
        case let .Section(headerVM: headerVM, items: _, key: key):
            self = .Section(headerVM: headerVM, items: items, key: key)
        }
    }
}

extension SectionModels {
    var headerVM: ViewModel? {
        switch self {
        case .Section(headerVM: let headerVM, items: _, key: _):
            return headerVM
        }
    }
}

