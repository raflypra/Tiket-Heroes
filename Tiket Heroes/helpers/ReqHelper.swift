//
//  ReqHelper.swift
//  Simanis
//
//  Created by GADA-63 on 16/05/20.
//  Copyright © 2020 Simanis. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

class ReqHelper {
    
    struct ResponseModel {
        var success : Bool
        var resCode : Int
        var data    : Data
        var json    : JSON
    }
    
    static func request(_ url: URLConvertible, method: HTTPMethod = .get ,parameters: Parameters? = nil, completion: @escaping (ResponseModel)->()){
        Alamofire.request(url, method: method, parameters: parameters, headers: getHeader()).responseString { response in
            switch response.result {
            case .success:
                let res     = response.result.value!
                let json    = JSON.init(parseJSON:res)
                print("============================= REQUEST LOG ====================================")
                print("- URL :\n", url)
                print("- RAW RES :\n", res)
                print("- PRETTY JSON :\n", json)
                print("============================== END REQUEST LOG ===============================")
                completion(ResponseModel(success: true, resCode: json["code"].intValue, data: response.data!, json: json))
            case .failure(let error):
                print(error)
                AlertHelper.checkConn()
                completion(ResponseModel(success: false, resCode: 404, data: Data(), json: JSON()))
            }
        }
    }
    
    static func request(_ url: URLConvertible, method: HTTPMethod = .get ,parameters: Parameters? = nil, encoding: JSONEncoding, completion: @escaping (ResponseModel)->()){
        Alamofire.request(url, method: method, parameters: parameters, encoding: encoding, headers: getHeader()).responseString { response in
            switch response.result {
            case .success:
                let res     = response.result.value!
                let json    = JSON.init(parseJSON:res)
                print("============================= REQUEST LOG ====================================")
                print("- URL :\n", url)
                print("- RAW RES :\n", res)
                print("- PRETTY JSON :\n", json)
                print("============================== END REQUEST LOG ===============================")
                completion(ResponseModel(success: true, resCode: json["code"].intValue, data: response.data!, json: json))
            case .failure(let error):
                print(error)
                AlertHelper.checkConn()
                completion(ResponseModel(success: false, resCode: 404, data: Data(), json: JSON()))
            }
        }
    }
    
    static func getHeader() -> HTTPHeaders {
        let headers:HTTPHeaders      = [
            "Accept"        : "application/json",
            "Authorization" : "Bearer " + (UserDefaults.standard.string(forKey: "access_token") ?? "")
        ]
        
        print(headers)
        
        return headers
    }
    
    static func getHeaderURLReq(url:String) -> URLRequest {
        let urlRequest          = URLRequest(url: URL(string: url)!)
//        if(SessionHelper.checkIsLogin()){
//            urlRequest.setValue("Bearer " + (UserDefaults.standard.string(forKey: "access_token") ?? ""), forHTTPHeaderField: "Authorization")
//        }
        return urlRequest
    }
    
}
