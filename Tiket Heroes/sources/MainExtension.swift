//
//  MainExtension.swift
//  KM Partner
//
//  Created by Rafly Prayogo on 11/11/20.
//

import Foundation
import UIKit
import CommonCrypto

extension UIView {
    
    func applyViewNavBarConstraints(width: Float, height: Float) {
        let widthConstraint             = self.widthAnchor.constraint(equalToConstant: CGFloat(width))
        let heightConstraint            = self.heightAnchor.constraint(equalToConstant: CGFloat(height))
        heightConstraint.isActive       = true
        widthConstraint.isActive        = true
    }
    
    func roundedView() {
        self.layer.cornerRadius         = self.frame.size.width/2
        self.clipsToBounds              = true
        self.layer.borderColor          = UIColor.white.cgColor
        self.layer.borderWidth          = 0
    }
    
    func customRoundedView(radius: CGFloat, width: CGFloat, color: UIColor) {
        self.layer.borderColor          = color.cgColor
        self.layer.borderWidth          = width
        self.layer.cornerRadius         = radius
    }
    
    func customRoundedView(radius: CGFloat) {
        self.layer.cornerRadius         = radius
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path    = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask    = CAShapeLayer()
        mask.path   = path.cgPath
        self.layer.mask = mask
    }
    
    func roundTop(radius:CGFloat = 8){
        self.clipsToBounds          = true
        self.layer.cornerRadius     = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
    }

    func roundBottom(radius:CGFloat = 8){
        self.clipsToBounds          = true
        self.layer.cornerRadius     = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        } else {
            // Fallback on earlier versions
        }
    }
    
    func dropShadowAll(radius: CGFloat,scale: Bool = true){
        layer.masksToBounds             = false
        layer.shadowColor               = UIColor.black.cgColor
        layer.shadowOpacity             = 0.2
        layer.shadowOffset              = .zero
        layer.shadowRadius              = radius
        layer.shouldRasterize           = true
        layer.rasterizationScale        = scale ? UIScreen.main.scale : 1
    }
    
    func dropShadow(radius: CGFloat,scale: Bool = true) {
        layer.masksToBounds             = false
        layer.shadowColor               = UIColor.black.cgColor
        layer.shadowOpacity             = 0.2
        layer.shadowOffset              = .init(width: 0, height: radius)
        layer.shadowRadius              = radius
        layer.shouldRasterize           = true
        layer.rasterizationScale        = scale ? UIScreen.main.scale : 1
    }
    
    func dropShadowBottom(radius: CGFloat,scale: Bool = true) {
        layer.masksToBounds             = false
        layer.shadowColor               = UIColor.black.cgColor
        layer.shadowOpacity             = 0.2
        layer.shadowOffset              = .init(width: 0, height: radius)
        layer.shadowRadius              = radius
        layer.shouldRasterize           = true
        layer.rasterizationScale        = scale ? UIScreen.main.scale : 1
    }
    
    func dropShadowTop(radius: CGFloat,scale: Bool = true) {
        layer.masksToBounds             = false
        layer.shadowColor               = UIColor.black.cgColor
        layer.shadowOpacity             = 0.2
        layer.shadowOffset              = .init(width: radius, height: 0)
        layer.shadowRadius              = radius
        layer.shouldRasterize           = true
        layer.rasterizationScale        = scale ? UIScreen.main.scale : 1
    }
    
    func makeDashedBorder(color: UIColor)  {
        let mViewBorder                 = CAShapeLayer()
        mViewBorder.strokeColor         = color.cgColor
        mViewBorder.lineDashPattern     = [2, 2]
        mViewBorder.frame               = self.bounds
        mViewBorder.fillColor           = nil
        mViewBorder.path                = UIBezierPath(rect: self.bounds).cgPath
        self.layer.addSublayer(mViewBorder)
    }
    
    func makeDashedBorder(color: UIColor, dashPatern: NSNumber, width: CGFloat)  {
        let mViewBorder                 = CAShapeLayer()
        mViewBorder.strokeColor         = color.cgColor
        mViewBorder.lineDashPattern     = [dashPatern, dashPatern]
        mViewBorder.lineWidth           = width
        mViewBorder.frame               = self.bounds
        mViewBorder.fillColor           = nil
        mViewBorder.path                = UIBezierPath(rect: self.bounds).cgPath
        self.layer.addSublayer(mViewBorder)
    }
    
}

extension UIImage{
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage   = cgImage!
        
        let width       = size.width
        let height      = size.height
        let bounds      = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace  = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo  = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context     = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
    
    func resizeWithPercentage(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull as Any])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
    
    func resizeTopAlignedToFill(newWidth: CGFloat) -> UIImage? {
        let newHeight = size.height * newWidth / size.width

        let newSize = CGSize(width: newWidth, height: newHeight)

        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
    
}

extension String  {
    
    var isNumber : Bool {
        get{
            return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        }
    }
    
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    var isAlphaWhiteSpace: Bool {
        return !isEmpty && range(of: "[^a-zA-Z\\s]", options: .regularExpression) == nil
    }
    var isPersonName: Bool {
        return !isEmpty && range(of: "[^a-zA-Z\\s\\,\\.]", options: .regularExpression) == nil
    }
    var isNonZero: Bool {
        return !isEmpty && range(of: "^[0]+$", options: .regularExpression) == nil
    }
    
    var isLowerCased: Bool {
        return !isEmpty && range(of: "[^a-z]", options: .regularExpression) == nil
    }
    
    //Validate Email
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    
    var htmlAttributedString: NSAttributedString? {
        return try? NSAttributedString(data: Data(utf8), options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
    }
    
    func match(_ regex: String) -> [[String]] {
        let nsString = self as NSString
        return (try? NSRegularExpression(pattern: regex, options: []))?.matches(in: self, options: [], range: NSMakeRange(0, count)).map { match in
            (0..<match.numberOfRanges).map { match.range(at: $0).location == NSNotFound ? "" : nsString.substring(with: match.range(at: $0)) }
        } ?? []
    }
    
    func leftPadding(toLength: Int, withPad character: Character) -> String {
        let stringLength = self.count
        if stringLength < toLength {
            return String(repeatElement(character, count: toLength - stringLength)) + self
        } else {
            return String(self.suffix(toLength))
        }
    }
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }
    
    var firstUppercased: String { return prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { return prefix(1).capitalized + dropFirst() }
    
    
    
    static let responseSuccess      = "success"
    static let responseFailed       = "failed"
    static let responseOK           = "OK"
    static let responseFail         = "failed"
}

extension CGFloat  {
    static let sheetKeyboardMin     = CGFloat(234)
    static let sheetKeyboardExp     = CGFloat(552.0)
}

extension UITabBarController {
    open override var childForStatusBarStyle: UIViewController? {
        return selectedViewController?.childForStatusBarStyle ?? selectedViewController
    }
}

extension UINavigationController {
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController?.childForStatusBarStyle ?? topViewController
    }
}
extension UITableView {
    
    func scrollToBottom(animated: Bool = true) {
        let sections = self.numberOfSections
        if(sections > 0){
            let rows = self.numberOfRows(inSection: sections - 1)
            if (rows > 0){
                self.scrollToRow(at: NSIndexPath(row: rows - 1, section: sections - 1) as IndexPath, at: .bottom, animated: animated)
            }
        }
    }
    
    func reloadWithoutAnimation() {
        let lastScrollOffset = contentOffset
        beginUpdates()
        endUpdates()
        layer.removeAllAnimations()
        setContentOffset(lastScrollOffset, animated: false)
    }
}
extension UILabel {
    func setHTMLFromString(htmlText: String) {
        let modifiedFont = String(format:"<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(self.font!.pointSize)\">%@</span>", htmlText)

        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue],
            documentAttributes: nil)

        self.attributedText = attrStr
    }
}

extension UIRefreshControl {
    func beginRefreshingManually() {
        if let scrollView = superview as? UIScrollView {
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y - frame.height), animated: true)
        }
        beginRefreshing()
    }
}

extension UICollectionView {
    func reloadWithoutAnimation(){
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        self.reloadData()
        CATransaction.commit()
    }
}

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
    
    var convertToString: String? {
        let jsonEncoder = JSONEncoder()
        if #available(iOS 13.0, *) {
            jsonEncoder.outputFormatting = .withoutEscapingSlashes
        } else {
            jsonEncoder.outputFormatting = .sortedKeys
        }
        do {
            let jsonData = try jsonEncoder.encode(self)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            return nil
        }
    }
}

extension UIDevice {
    var hasNotch: Bool {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if #available(iOS 11.0, *) {
            return window!.safeAreaInsets.bottom > 0
        } else {
            return false
        }
    }
    // Device info
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> String {
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod touch (5th generation)"
            case "iPod7,1":                                 return "iPod touch (6th generation)"
            case "iPod9,1":                                 return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad11,4", "iPad11,5":                    return "iPad Air (3rd generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }

        return mapToDevice(identifier: identifier)
    }()
}

extension UIViewController {
    func setNavigationLogo() {
        DispatchQueue.main.async {
            let imageView           = UIImageView(image: UIImage(named: "logo_small_white_kp"))
            imageView.contentMode   = .scaleAspectFit
            imageView.clipsToBounds = true
            imageView.frame         = CGRect(x: 0, y: 0, width: 200, height: 30)
            imageView.applyNavBarConstraints(width: 200, height: 30)
            self.navigationItem.titleView = imageView
        }
    }
    
    open override func awakeFromNib() {
        navigationItem.backBarButtonItem    = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

extension UIImageView {

    func applyNavBarConstraints(width: Float, height: Float) {
        let widthConstraint         = self.widthAnchor.constraint(equalToConstant: CGFloat(width))
        let heightConstraint        = self.heightAnchor.constraint(equalToConstant: CGFloat(height))
        heightConstraint.isActive   = true
        widthConstraint.isActive    = true
    }
    
    func setEmployeeAva() {
        self.contentMode            = .top
        self.clipsToBounds          = true
        self.image                  = self.image?.resizeTopAlignedToFill(newWidth: self.frame.width)
        self.roundedView()
    }
    
    func setEmployeeAva(image: UIImage) {
        self.contentMode            = .top
        self.clipsToBounds          = true
        self.image                  = image.resizeTopAlignedToFill(newWidth: self.frame.width)
        self.roundedView()
    }
    
}

extension UISearchBar {
    var textField : UITextField{
        return self.value(forKey: "searchField") as! UITextField
    }
}

extension Int {
    static let apiCodeNotFound      = 10000
    static let apiCodeActive        = 10001
    static let apiCodeRequest       = 10002
    static let apiCodeBlocked       = 10003
    static let apiCodeDisabled      = 10004
    static let apiCodeUnknown       = 10005
}
