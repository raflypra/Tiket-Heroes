//
//  CacheHelper.swift
//  Tiket Heroes
//
//  Created by Rafly Prayogo on 18/12/20.
//

import Foundation
import Alamofire
import SwiftyJSON

class CacheHelper{
    
    static let KEY_DATA_CACHE       = "dataCache"
    static let KEY_CACHE_STATUS     = "cacheStatus"
    
    public static func createSession(_ data:Data){
        UserDefaults.standard.set(true, forKey: KEY_CACHE_STATUS)
        UserDefaults.standard.set(data, forKey: KEY_DATA_CACHE)
    }
    
    public static func checkIsCached() -> Bool {
        let status = UserDefaults.standard.bool(forKey: KEY_CACHE_STATUS)
        return status
    }

    public static func get() -> Data {
        return UserDefaults.standard.data(forKey: KEY_DATA_CACHE)!
    }
}
