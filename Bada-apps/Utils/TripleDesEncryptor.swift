//
//  TripleDesEncryptor.swift
//  Central Mega Kencana
//
//  Created by Handy Handy on 08/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import Foundation
import CommonCrypto

class TripleDesEncryptor {
    enum TripleDesError: Error {
        case KeyError((String, Int))
        case IVError((String, Int))
        case CryptorError((String, Int))
    }
    
    
    func encrypt(data: Data) throws -> Data {
        if Encryption.validKeyLength.contains(Encryption.keyLength) == false {
            throw TripleDesError.KeyError(("Invalid key length", Encryption.keyLength))
        }
        
        let cryptLength = size_t(data.count + kCCBlockSize3DES)
        var cryptData = Data(count: cryptLength)
        
        var numBytesEncrypted: size_t = 0
        
        let cryptStatus = cryptData.withUnsafeMutableBytes {cryptBytes in
            data.withUnsafeBytes {dataBytes in
                Encryption.key!.withUnsafeBytes {keyBytes in
                    CCCrypt(Encryption.operationEncrypt,
                            Encryption.algorithm,
                            Encryption.options,
                            keyBytes, Encryption.keyLength,
                            cryptBytes,
                            dataBytes, data.count,
                            cryptBytes, cryptLength,
                            &numBytesEncrypted)
                }
            }
        }
        
        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            cryptData.count = numBytesEncrypted
        }else {
            throw TripleDesError.CryptorError(("Encryption Error", Int(cryptStatus)))
        }
        
        return cryptData
    }
    
    func decrypt(data: Data) throws -> Data {
        if Encryption.validKeyLength.contains(Encryption.keyLength) == false {
            throw TripleDesError.KeyError(("Invalid key length", Encryption.keyLength))
        }
        
        let decryptLength = size_t(data.count)
        var decryptData = Data(count: decryptLength)
        
        var numBytesDecrypted :size_t = 0
        
        let cryptStatus = decryptData.withUnsafeMutableBytes {cryptBytes in
            data.withUnsafeBytes {dataBytes in
                Encryption.key!.withUnsafeBytes {keyBytes in
                    CCCrypt(Encryption.operationDecrypt,
                            Encryption.algorithm,
                            Encryption.options,
                            keyBytes, Encryption.keyLength,
                            cryptBytes,
                            dataBytes, decryptLength,
                            cryptBytes, decryptLength,
                            &numBytesDecrypted)
                }
            }
        }
        
        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            decryptData.count = numBytesDecrypted
        }
        else {
            throw TripleDesError.CryptorError(("Decryption failed", Int(cryptStatus)))
        }
        
        return decryptData
    }
    
}
