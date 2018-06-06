//
//  Array.swift
//  Bada-apps
//
//  Created by octavianus on 06/06/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import Foundation

extension Array where Element:Hashable {
    var unique: [Element] {
        return Array(Set(self))
    }
}
