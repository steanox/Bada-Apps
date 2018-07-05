//
//  FaceID.swift
//  Bada-apps
//
//  Created by Handy Handy on 08/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import Foundation
import LocalAuthentication

enum ErrorFaceID {
    case isSuccess
    case notSupported
    case unknownError
}

class FaceID {
    
    init() {}
    
    typealias onResponse = ((ErrorFaceID)->())
    
    func identifiyingFaceID(_ completion: @escaping onResponse) {
        
        guard #available(iOS 8.0, *) else {
            return completion(.notSupported)
        }
        
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            print("Error - canEvaluatePolicy")
            return completion(.unknownError)
        }
        
        let reason = "Face ID authentication"
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { isAuthorized, error in
            guard isAuthorized == true else {
                print("Error - evaluatePolicy")
                return completion(.unknownError)
            }
            
            completion(.isSuccess)
        }
        
    }
    
    
}
