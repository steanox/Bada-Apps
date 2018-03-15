//
//  NetworkProcessor.swift
//  Bada-apps
//
//  Created by Handy Handy on 13/03/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import Foundation

class NetworkProcessor {
    lazy var configuration: URLSessionConfiguration = URLSessionConfiguration.default
    lazy var session = URLSession(configuration: self.configuration)
    
    let url: URL?
    var parameter: Any?
    var method: Method
    
    typealias JSONDictionaryHandler = ((Data?)->())
    
    init(method: Method, url: URL, parameter: Any? ) {
        self.method = method
        self.url = url
        self.parameter = parameter
    }
    
    
    func processed(_ completion: @escaping JSONDictionaryHandler) {
        guard let url = self.url else {return completion(nil)}
        var request = URLRequest(url: url)
        request.httpMethod = self.method.rawValue
        // setting header
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        
        // setting body with decoder,
        // so make sure you make object with codable
        if method == .post{
            request.httpBody = parameter as? Data
//            let encoder = JSONEncoder()
//            do{
//                let jsonData = try encoder.encode(parameter)
//                request.httpBody = jsonData
//            }catch {
//                print("error encoder: \(error.localizedDescription)")
//                completion(nil)
//            }
        }
        
        // create session
        let dataTask = session.dataTask(with: request) { (data, resp, err) in
            if err == nil {
                guard let httpResp = resp as? HTTPURLResponse else {
                    return completion(nil)
                }
                switch httpResp.statusCode {
                case 200:
                    completion(data)
                    
                default:
                    print("HTTP Response Code: \(httpResp.statusCode)")
                    completion(nil)
                }
            } else {
                print("error session: \(String(describing: err?.localizedDescription))")
                completion(nil)
            }
        }
        
        dataTask.resume()
        
    }
    
}

enum Method: String {
    case get = "GET"
    case post = "POST"
}

