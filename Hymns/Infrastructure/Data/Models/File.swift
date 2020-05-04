//
//  File.swift
//  Hymns
//
//  Created by Luke Lu on 5/4/20.
//  Copyright © 2020 skywalkerdude. All rights reserved.
//

import Foundation

struct Fileee: Hashable, Equatable {
    let hymnType: HymnType
    let hymnNumber: String
    let bbb: String?
    let ccc: String?
}

extension Fileee {

    // Allows us to use a customer initializer along with the default memberwise one
    // https://www.hackingwithswift.com/articles/106/10-quick-swift-tips
    init(hymnType: HymnType, hymnNumber: String, bbb: String? = nil) {
        self.hymnType = hymnType
        self.hymnNumber = hymnNumber
        self.bbb = bbb
        self.ccc = "SDF"
    }
}
