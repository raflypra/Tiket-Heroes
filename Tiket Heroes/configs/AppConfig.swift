//
//  AppConfig.swift
//  KM Partner
//
//  Created by Rafly Prayogo on 11/11/20.
//

import Foundation
import UIKit
import LoadingPlaceholderView

class AppConfig {
    
    // ====================== CONFIGURATION ======================= //
    public static let ROUND_CARDVIEW                = CGFloat(6)
    public static let ROUND_BSHEET                  = CGFloat(16)
    public static let ROUND_ALERT                   = CGFloat(8)
    public static let ROUND_BTN                     = CGFloat(25)
    public static let CARD_SHADOW                   = CGFloat(2)
    
    // ====================== APIKEY / SECRET ======================= //
    public static let MAPS_API_KEY                  = ""
    public static let GEOCODING_API_KEY             = ""
    
    // ====================== DEFAULT VALUE ======================= //
    public static let DEF_FAIL_IMG                  = "https://imagefailed.com"
    public static let DEF_DATE                      = "1970-01-01 00:00:00"
    public static let DEF_LATITUDE                  = -1.561704
    public static let DEF_LONGITUDE                 = 103.442507
    public static let DEF_SIZE_NAV_ICON             = 24
    public static let DEF_SPACING_NAV_ICON          = 35
    
    public static let DATE_MORNING                  = Calendar.current.date(bySettingHour: 11, minute: 0, second: 0, of: Date())!
    public static let DATE_NOON                     = Calendar.current.date(bySettingHour: 15, minute: 0, second: 0, of: Date())!
    public static let DATE_AFTERNOON                = Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: Date())!
    public static let DATE_NIGHT                    = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date())!
    
    public static let DATE_ABSENCE                  = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!
    public static let DATE_BREAK_WORK               = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!
    public static let DATE_DONE_BREAK               = Calendar.current.date(bySettingHour: 13, minute: 0, second: 0, of: Date())!
    public static let DATE_GO_HOME                  = Calendar.current.date(bySettingHour: 16, minute: 30, second: 0, of: Date())!
    
    // ====================== TEMPORARY ======================= //
    public static var SHIMMER                       = LoadingPlaceholderView()
    
    
    // ====================== APP INFO ======================= //
    public static var appName : String {
        return readFromInfoPlist(withKey: "CFBundleName") ?? "(unknown app name)"
    }
    public static var version : String {
        return readFromInfoPlist(withKey: "CFBundleShortVersionString") ?? "(unknown app version)"
    }
    public static var build : String {
        return readFromInfoPlist(withKey: "CFBundleVersion") ?? "(unknown build number)"
    }
    public static var minimumOSVersion : String {
        return readFromInfoPlist(withKey: "MinimumOSVersion") ?? "(unknown minimum OSVersion)"
    }
    public static var copyrightNotice : String {
        return readFromInfoPlist(withKey: "NSHumanReadableCopyright") ?? "(unknown copyright notice)"
    }
    public static var bundleIdentifier : String {
        return readFromInfoPlist(withKey: "CFBundleIdentifier") ?? "(unknown bundle identifier)"
    }
    public static let infoPlistDictionary = Bundle.main.infoDictionary
    public static func readFromInfoPlist(withKey key: String) -> String? {
        return infoPlistDictionary?[key] as? String
    }
}
