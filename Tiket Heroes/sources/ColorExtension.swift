//
//  ColorExtension.swift
//  KM Partner
//
//  Created by Rafly Prayogo on 11/11/20.
//

import Foundation
import UIKit

extension UIColor {
    
    static let primary              = UIColor(hex: "82CA9E")
    static let primaryDark          = UIColor(hex: "3FB686")
    static let accent               = UIColor(hex: "E04C25")
    static let customDarkGray       = UIColor(hex: "737475")
    static let grayBg               = UIColor(hex: "EEEEEE")
    static let grayYoung            = UIColor(hex: "f5f5f5")
    static let groupBg              = UIColor(hex: "F2F2F7")
    static let bgColor              = UIColor(hex: "e5e5e5")
    
    // paleteColor
    static let palGreen             = UIColor(hex: "81c784")
    static let palBlue              = UIColor(hex: "42a5f5")
    static let palRed               = UIColor(hex: "E11900")
    static let palOrange            = UIColor(hex: "FFC043")
    static let palCyan              = UIColor(hex: "009EA9")
    static let palYellow            = UIColor(hex: "FFC043")
    static let palDisable           = UIColor(hex: "BCBCBD")
    
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
