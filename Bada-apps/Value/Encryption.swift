//
//  Encryption.swift
//  Bada-apps
//
//  Created by Handy Handy on 08/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import Foundation
import CommonCrypto

struct Encryption {
    static let key = "313233343536373839313233343536373839313233343536".toData()
    static let iv: Data = Data.init(bytes: [00,00,00,00,00,00,00,00])
    
    static let validKeyLength = [kCCKeySize3DES]
    static let ivSize = kCCBlockSize3DES
    
    static let operationEncrypt = CCOperation(kCCEncrypt)
    static let operationDecrypt = CCOperation(kCCDecrypt)
    static let algorithm = CCAlgorithm(kCCAlgorithm3DES)
    static let options: CCOptions = CCOptions(kCCOptionPKCS7Padding)
    static let keyLength = key!.count
}
