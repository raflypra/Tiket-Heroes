//
//  MainHelper.swift
//  Simanis
//
//  Created by GADA-63 on 28/04/20.
//  Copyright © 2020 Simanis. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import AVKit
import AVFoundation
import SwiftyJSON
import MapKit
import LoadingPlaceholderView

class MainHelper {
    // ======================= NAVIGATIONS ================== //
        
    @available(iOS 13.0, *)
    static func navAppearance (_ bgColor:UIColor, _ textAttr:[NSAttributedString.Key : UIColor]) -> UINavigationBarAppearance {
        let backAppearance                          = UIBarButtonItemAppearance()
        backAppearance.normal.titleTextAttributes   = [NSAttributedString.Key.foregroundColor: UIColor.clear]
        let appearance                              = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor                  = bgColor
        appearance.titleTextAttributes              = textAttr
        appearance.shadowColor                      = .clear
        appearance.backButtonAppearance             = backAppearance
        return appearance
    }
    
    static func setDarkNav(_ con:UIViewController){
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        if #available(iOS 13.0, *) {
            let appearance                                                  = navAppearance(.primary, textAttributes)
            con.navigationController?.navigationBar.standardAppearance      = appearance
            con.navigationController?.navigationBar.scrollEdgeAppearance    = appearance
            con.navigationController?.navigationBar.compactAppearance       = appearance
            
//            if let nav = con.navigationController as? NavbarController {
//               nav.requiredStatusBarStyle = .darkContent
//            }
        }
        con.navigationController?.navigationBar.barStyle                    = .black
        con.navigationController?.navigationBar.barTintColor                = .primary
        con.navigationController?.navigationBar.tintColor                   = .white
        con.navigationController?.navigationBar.isTranslucent               = false
        con.navigationController?.navigationBar.titleTextAttributes         = textAttributes
        con.navigationController?.navigationBar.shadowImage                 = nil
        con.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        con.navigationController?.navigationBar.shadowImage                 = UIImage()
        setTransparentStatusBar(con)
    }
    
    static func setLightNav(_ con:UIViewController){
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.darkText]
        if #available(iOS 13.0, *) {
            let appearance                                                  = navAppearance(.white, textAttributes)
            con.navigationController?.navigationBar.standardAppearance      = appearance
            con.navigationController?.navigationBar.scrollEdgeAppearance    = appearance
            con.navigationController?.navigationBar.compactAppearance       = appearance
            
//            if let nav = con.navigationController as? NavbarController {
//               nav.requiredStatusBarStyle = .lightContent
//            }
        }
        con.navigationController?.navigationBar.barStyle                    = .default
        con.navigationController?.navigationBar.barTintColor                = .white
        con.navigationController?.navigationBar.tintColor                   = .darkText
        con.navigationController?.navigationBar.isTranslucent               = true
        con.navigationController?.navigationBar.titleTextAttributes         = textAttributes
        con.navigationController?.navigationBar.shadowImage                 = nil
        con.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        con.navigationController?.navigationBar.shadowImage                 = UIImage()
        setTransparentStatusBar(con)
    }
    
    static func setTransparentStatusBar(_ sender: UIViewController){
        sender.setNeedsStatusBarAppearanceUpdate()
        let window          = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        for subViews in window!.subviews {
            if(subViews.tag == 919){
               subViews.removeFromSuperview()
            }
        }
        var statusBarView:UIView
        if #available(iOS 13.0, *) {
            statusBarView   = UIView(frame: (window?.windowScene?.statusBarManager!.statusBarFrame)!)
        } else {
            statusBarView   = UIApplication.shared.value(forKey: "statusBar") as! UIView
        }
        statusBarView.backgroundColor   = .darkText
        statusBarView.alpha             = 0.3
        statusBarView.tag               = 919
        window!.addSubview(statusBarView)
    }
    
    static func setViewBehindStatusBar(_ sender: UIViewController, _ topConstraint:NSLayoutConstraint, removeNavigation:Bool){
        if(removeNavigation){
            topConstraint.constant          = topConstraint.constant - getStatusBarHeight() - (sender.navigationController?.navigationBar.frame.height ?? 0)
        }else{
            topConstraint.constant          = topConstraint.constant - getStatusBarHeight()
        }
        sender.view.tag                     = 900
        
//        sender.setNeedsStatusBarAppearanceUpdate()
//        let window          = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
//        let statusBarView   = UIView(frame: (window?.windowScene?.statusBarManager!.statusBarFrame)!)
//        statusBarView.backgroundColor   = .black
//        statusBarView.alpha             = 0.4
//        for sv in window!.subviews{
//            sv.removeFromSuperview()
//        }
//        window!.addSubview(statusBarView)
    }
    
    public static func addBackButton(_ con: UIViewController) -> UIBarButtonItem {
        let btnBack = UIButton(type: .custom)
        btnBack.setImage(UIImage(named: "back"), for: .normal)
        btnBack.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        btnBack.applyViewNavBarConstraints(width: 22, height: 22)
//        if let chatVc = con as? ChatConversationViewController{
//            btnBack.addTarget(con, action: #selector(chatVc.doBack(_:)), for: .touchUpInside)
//        }
        let itemBack = UIBarButtonItem(customView: btnBack)
        
        return itemBack
    }
    
    static func addMultiRightBarButtons( _ con :UIViewController, _ selectors: [Selector], _ images:[UIImage]){
        DispatchQueue.main.async {
            var i = 0
            var barButtonItems = [UIBarButtonItem]()
            selectors.forEach({ (sel) in
                let btn    = UIButton(type: .custom)
                btn.setImage(images[i], for: .normal)
                btn.frame  = CGRect(x: 0, y: 0, width: AppConfig.DEF_SIZE_NAV_ICON, height: AppConfig.DEF_SIZE_NAV_ICON)
                btn.applyViewNavBarConstraints(width: Float(AppConfig.DEF_SIZE_NAV_ICON), height: Float(AppConfig.DEF_SIZE_NAV_ICON))
                btn.addTarget(con, action: sel, for: .touchUpInside)
                let item   = UIBarButtonItem(customView: btn)
                barButtonItems.append(item)
                i += 1
            })
            con.navigationItem.setRightBarButtonItems(barButtonItems, animated: true)
        }
    }
    
    static func removeRightTextBarButton( _ con :UIViewController){
        DispatchQueue.main.async {
            con.navigationItem.setRightBarButtonItems([], animated: true)
        }
    }
    
    static func addRightTextBarButton( _ con :UIViewController, _ selector: Selector, _ title:String){
        DispatchQueue.main.async {
            let item1           = UIBarButtonItem(title: title, style: .done, target: con, action: selector)
            if((con.navigationController?.navigationBar.barStyle)! == UIBarStyle.black){
                item1.tintColor     = .white
            }else{
                item1.tintColor     = .primary
            }
            
            con.navigationItem.setRightBarButtonItems([item1], animated: true)
        }
    }
    
    static func addRightBarButton( _ con :UIViewController, _ selector: Selector, _ image:UIImage){
        DispatchQueue.main.async {
            let btn1    = UIButton(type: .custom)
            btn1.setImage(image, for: .normal)
            btn1.frame  = CGRect(x: 0, y: 0, width: AppConfig.DEF_SIZE_NAV_ICON, height: AppConfig.DEF_SIZE_NAV_ICON)
            btn1.applyViewNavBarConstraints(width: Float(AppConfig.DEF_SIZE_NAV_ICON), height: Float(AppConfig.DEF_SIZE_NAV_ICON))
            btn1.addTarget(con, action: selector, for: .touchUpInside)
            let item1   = UIBarButtonItem(customView: btn1)
            con.navigationItem.setRightBarButtonItems([item1], animated: true)
        }
    }
    
    static func addLeftBarButton( _ con :UIViewController, _ selector: Selector, _ image:UIImage){
        DispatchQueue.main.async {
            let btn1    = UIButton(type: .custom)
            btn1.setImage(image, for: .normal)
            btn1.frame  = CGRect(x: 0, y: 0, width: AppConfig.DEF_SIZE_NAV_ICON, height: AppConfig.DEF_SIZE_NAV_ICON)
            btn1.applyViewNavBarConstraints(width: Float(AppConfig.DEF_SIZE_NAV_ICON), height: Float(AppConfig.DEF_SIZE_NAV_ICON))
            btn1.addTarget(con, action: selector, for: .touchUpInside)
            let item1   = UIBarButtonItem(customView: btn1)
            con.navigationItem.setLeftBarButtonItems([item1], animated: true)
        }
    }
    
    static func addCustomBackView(_ sender: UIViewController, _ headerHeight: NSLayoutConstraint, _ selector: Selector){
        let backView                = UIView(frame: CGRect(x: 0, y: getStatusBarHeight(), width: 80, height: headerHeight.constant - getStatusBarHeight() - 10))
//        backView.backgroundColor    = .red
        sender.view.addSubview(backView)
        onTap(sender,backView, selector)
    }
    
    // ======================= ON TAP RECOGNIZERS ================== //
    
    static func onTap(_ sender: UIViewController, _ view:UIStackView,  _ selector:Selector){
        let tapGestures  = UITapGestureRecognizer(target: sender, action: selector)
        view.addGestureRecognizer(tapGestures)
        view.isUserInteractionEnabled    = true
    }
    
    static func onTap(_ sender: UIViewController,_ view:UIView,  _ selector:Selector){
        let tapGestures  = UITapGestureRecognizer(target: sender, action: selector)
        view.addGestureRecognizer(tapGestures)
        view.isUserInteractionEnabled    = true
    }
    
    static func onTap(_ sender: UIViewController,_ view:UIImageView,  _ selector:Selector){
        let tapGestures  = UITapGestureRecognizer(target: sender, action: selector)
        view.addGestureRecognizer(tapGestures)
        view.isUserInteractionEnabled    = true
    }
    
    static func onTap(_ sender: UITableViewCell,_ view:UIView,  _ selector:Selector){
        let tapGestures  = UITapGestureRecognizer(target: sender, action: selector)
        view.addGestureRecognizer(tapGestures)
        view.isUserInteractionEnabled    = true
    }
    
    // ======================= VC CYCLE ================= //
    
    static func popBack(sender: UIViewController, nb: Int) {
        if let viewControllers: [UIViewController] = sender.navigationController?.viewControllers {
            guard viewControllers.count < nb else {
                sender.navigationController?.popToViewController(viewControllers[viewControllers.count - nb], animated: true)
                return
            }
        }
    }
    
    static func pushWithHideBottomBar(_ sender:UIViewController, _ dest:UIViewController){
        sender.tabBarController?.tabBar.isHidden    = true
        sender.navigationController?.pushViewController(dest, animated: true)
    }
    
    static func instantiateVC(_ storyboard: UIStoryboard, _ id: String) -> UIViewController? {
        if #available(iOS 13.0, *) {
            return storyboard.instantiateViewController(identifier: id)
        } else {
            return storyboard.instantiateViewController(withIdentifier: id)
        }
    }
    
    public static func getTopVC() -> UIViewController{
        var topController                   = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
        while let presentedViewController   = topController?.presentedViewController {
            topController                   = presentedViewController
        }
        return topController!
    }
    
    // ======================= OTHER HELPERS ================== //
    
    
    static func jsonToDictionary(from text: String) -> [[String: Any]]? {
        guard let data = text.data(using: .utf8) else { return nil }
        let anyResult = try? JSONSerialization.jsonObject(with: data, options: [])
        return anyResult as? [[String: Any]]
    }
    
    
    static func actionSheetAlert(_ sender:UIViewController, _ actions:[UIAlertAction], _ title:String, _ msg:String, _ cancelBtn: Bool = true){
        let alertSec    = UIAlertController(title: (title == "" ? nil:title), message: (msg == "" ? nil:msg), preferredStyle: UIAlertController.Style.actionSheet)
        actions.forEach { (act) in
            alertSec.addAction(act)
        }
        if(cancelBtn){
            alertSec.addAction(UIAlertAction(title: "Batal", style: UIAlertAction.Style.cancel, handler: nil))
        }
        alertSec.popoverPresentationController?.sourceView = sender.view
        alertSec.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        sender.present(alertSec, animated: true, completion: nil)
    }
    
    static func getDecoder() -> JSONDecoder {
        let decoder                 = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    static func getRandomColor() -> UIColor{
        let randomRed:CGFloat       = CGFloat(drand48())
        let randomGreen:CGFloat     = CGFloat(drand48())
        let randomBlue:CGFloat      = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
    static func getStatusBarHeight() -> CGFloat {
        let window  = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        var height:CGFloat
        if #available(iOS 13.0, *) {
            height  = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            let statusBarView   = UIApplication.shared.value(forKey: "statusBar") as! UIView
            height              = statusBarView.frame.height
        }
        return height
    }
    
    public static func playVideoUrl(sender:UIViewController, url:URL, fill:Bool = false){
        let playerVC    = AVPlayerViewController()
        let playerView  = AVPlayer(url: url)
        playerVC.player = playerView
        if(fill){
            playerVC.videoGravity = .resizeAspectFill
        }
        sender.present(playerVC, animated: true) {
            playerVC.player?.play()
        }
    }
    
    public static func generateOTP() -> String {
        let otp = String(Int.random(in: 0 ..< 10)) + String(Int.random(in: 0 ..< 10)) + String(Int.random(in: 0 ..< 10)) + String(Int.random(in: 0 ..< 10))
        return otp
    }
    
    public static func getUniqueFilename() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddhhmmssSSS"
        return formatter.string(from: Date()) + String(Int.random(in: 10..<100))
    }
    
    static func convertCLLocationDistanceToKM ( lat1:Double, long1:Double, lat2:Double, long2:Double) -> String {
        let coordinate1     = CLLocation(latitude: lat1, longitude: long1)
        let coordinate2     = CLLocation(latitude: lat2, longitude: long2)
        let targetDistance  = coordinate1.distance(from: coordinate2)
        let value           = targetDistance/1000
        return String(format:"%.1f", value)
    }
    
//    static func getSlider(url: String, defImg: UIImage, bgColor:UIColor, contentMode: UIImageView.ContentMode = .scaleAspectFill, rounded: Bool = false, bottom: CGFloat = 0) -> BannerSliderViewController {
//        let con         = GadaHelper.instantiateVC(.mainStoryboard, "BannerSliderViewController") as! BannerSliderViewController
//        con.url                 = url
//        con.defImg              = defImg
//        con.contentMode         = contentMode
//        con.backgroundColor     = bgColor
//        con.rounded             = rounded
//        con.bottom              = bottom
//        return con
//    }
    
    static func getGridLayout(_ divider: CGFloat, _ height:CGFloat, _ padding: CGFloat) -> UICollectionViewFlowLayout{
        let layout: UICollectionViewFlowLayout  = UICollectionViewFlowLayout()
        let width                               = (UIScreen.main.bounds.width - padding)
        layout.sectionInset                     = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.itemSize                         = CGSize(width: width / divider, height: height)
        layout.minimumInteritemSpacing          = 0
        layout.minimumLineSpacing               = 0
        return layout
    }
    
    static func generateLabelStrata (text : String) -> UILabel {
        let label           = UILabel()
        label.textColor     = .darkText
        label.font          = UIFont.systemFont(ofSize: 12.0)
        label.frame         = CGRect(x: 0, y: 0, width: 100, height: 12)
        label.text          = text
        label.textAlignment = .center
        return label
    }
    
    static func checkJSONData(_ json:JSON) -> Bool {
        if(json["count"].intValue > 0 && json["data"].array != nil){
            return true
        }else{
            if(json["data"].array != nil && (json["data"].array?.count)! > 0){
                return true
            }else{
                return false
            }
        }
    }
    
    static func checkJSONStatus(_ json:JSON) -> Bool {
        if(json["Status"].stringValue.lowercased() == .responseSuccess || json["status"].stringValue.lowercased() == .responseSuccess || json["status"].stringValue.lowercased() == "200"){
            return true
        }else{
            if(json.array != nil && (json.array?.count)! > 0){
                if(json.arrayValue[0]["Status"].stringValue.lowercased() == .responseSuccess){
                    return true
                }else{
                    return false
                }
            }else{
                return false
            }
        }
    }
    
    static func checkZendeskJSONStatus(_ json:JSON) -> Bool {
        if(json["ticket"].exists()){
            return true
        }else{
            return false
        }
    }
    
    static func checkJSONStatusFailed(_ json:JSON) -> Bool {
        if(json["Status"].stringValue.lowercased() == .responseFailed || json["status"].stringValue.lowercased() == .responseFailed){
            return true
        }else{
            return false
        }
    }
    
    static func estimatedTextFrame(text: String, font: UIFont) -> CGRect {
        let size = CGSize(width: 200, height: 1000) // temporary size
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size,
                                                   options: options,
                                                   attributes: [NSAttributedString.Key.font: font],
                                                   context: nil)
    }
    
    static func setViewSegmentedControl(_ sc: UISegmentedControl){
        let activeState     = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0), NSAttributedString.Key.foregroundColor: UIColor.white]
        let inActiveState   = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0), NSAttributedString.Key.foregroundColor: UIColor.darkText]
        sc.setTitleTextAttributes(activeState as [NSAttributedString.Key : Any], for: .selected)
        sc.setTitleTextAttributes(inActiveState as [NSAttributedString.Key : Any], for: .normal)
    }
    
    static func setViewSegmentedControl(_ sc: UISegmentedControl, activeColor: UIColor, inActiveColor:UIColor){
        let activeState     = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0), NSAttributedString.Key.foregroundColor: activeColor]
        let inActiveState   = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0), NSAttributedString.Key.foregroundColor: inActiveColor]
        sc.setTitleTextAttributes(activeState as [NSAttributedString.Key : Any], for: .selected)
        sc.setTitleTextAttributes(inActiveState as [NSAttributedString.Key : Any], for: .normal)
    }
    
    static func addGradientLayer(_ mainView: UIView,_ layerView: UIView, _ color1:UIColor, _ color2:UIColor, _ radius:Float){
        let gradientLayer:CAGradientLayer   = CAGradientLayer()
        gradientLayer.frame                 = CGRect(x: 0, y: 0, width: ((mainView.frame.width - 42) / 2), height: layerView.frame.height)
        gradientLayer.colors                = [color1.cgColor, color2.cgColor]
        gradientLayer.startPoint            = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint              = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.cornerRadius          = CGFloat(radius)
        layerView.layer.addSublayer(gradientLayer)
    }
    
    static func addGradientLayer(_ layerView: UIView, _ color1:UIColor, _ color2:UIColor, _ radius:Float){
        let gradientLayer:CAGradientLayer   = CAGradientLayer()
        gradientLayer.frame                 = CGRect(x: 0, y: 0, width: layerView.frame.width, height: layerView.frame.height)
        gradientLayer.colors                = [color1.cgColor, color2.cgColor]
        gradientLayer.startPoint            = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint              = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.cornerRadius          = CGFloat(radius)
        layerView.layer.addSublayer(gradientLayer)
    }
    
    public static func setShimmer(_ view: UIView, _ tableView: UITableView, _ cellID:String) {
        setShimmer(view, tableView, cellID, 20)
    }
    
    public static func setShimmer(_ view: UIView, _ tableView: UITableView, _ cellID:String, _ initCount:Int) {
        var arr = [String]()
        for _ in 1...initCount {
            arr.append(cellID)
        }
        tableView.coverableCellsIdentifiers     = arr
        AppConfig.SHIMMER.cover(view)
    }
    
//    public static func setShimmer(_ view: UIView, _ collView: UICollectionView, _ cellID:String) {
//        var arr = [String]()
//        for _ in 1...20 {
//            arr.append(cellID)
//        }
//        collView.coverableCellsIdentifiers      = arr
//        AppConfig.SHIMMER.cover(view)
//    }
    
    static func setPasswordEye(_ sender: UIViewController,_ textField:UITextField, _ selector:Selector){
        let rightButton                 = UIButton(type: .custom)
        rightButton.setImage(UIImage(named: "ic_matatutup"), for: .normal)
        rightButton.frame               = CGRect(x:0, y:0, width: AppConfig.DEF_SIZE_NAV_ICON, height: AppConfig.DEF_SIZE_NAV_ICON)
        rightButton.applyViewNavBarConstraints(width: Float(AppConfig.DEF_SIZE_NAV_ICON), height: Float(AppConfig.DEF_SIZE_NAV_ICON))
        rightButton.addTarget(sender, action: selector, for: .touchUpInside)
        textField.rightViewMode         = .always
        textField.rightView             = rightButton
    }
    
    static func passwordEyeTextHide (_ btn: UIButton, _ textField:UITextField){
       if (btn.tag == 0){
           textField.isSecureTextEntry  = false
           btn.tag                      = 1
           btn.setImage(UIImage(named: "ic_matabuka"), for: .normal)
       }else{
           textField.isSecureTextEntry  = true
           btn.tag                      = 0
           btn.setImage(UIImage(named: "ic_matatutup"), for: .normal)
       }
    }
    
    static func getDirection(_ sender: UIViewController, _ latitude: Double, _ longitude:Double){
        var alertActions = [UIAlertAction]()
        alertActions.append(UIAlertAction(title: "Buka dengan Google Maps", style: .default, handler: { action in
            if(UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)){
                if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(String(latitude)),\(String(longitude))&directionsmode=driving") {
                    UIApplication.shared.open(url, options: [:])
                }
            }else{
                if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(String(latitude)),\(String(longitude))&directionsmode=driving") {
                    UIApplication.shared.open(urlDestination)
                }
            }        }))
        alertActions.append(UIAlertAction(title: "Buka dengan Maps", style: .default, handler: { action in
            let url = "http://maps.apple.com/maps?saddr=\(String(latitude)),\(String(longitude))"
            UIApplication.shared.open(URL(string:url)!)
        }))
        actionSheetAlert(sender, alertActions, "", "")
    }
    
    static func getDirection(_ sender: UIViewController, _ sLatitude: Double, _ sLongitude:Double, _ dLatitude: Double, _ dLongitude:Double){
        var alertActions = [UIAlertAction]()
        alertActions.append(UIAlertAction(title: "Buka dengan Google Maps", style: .default, handler: { action in
            if(UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)){
                if let url = URL(string: "comgooglemaps-x-callback://?saddr=\(String(sLatitude)),\(String(sLongitude))&daddr=\(String(dLatitude)),\(String(dLongitude))&directionsmode=driving") {
                    UIApplication.shared.open(url, options: [:])
                }
            }else{
                if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=\(String(sLatitude)),\(String(sLongitude))&daddr=\(String(dLatitude)),\(String(dLongitude))&directionsmode=driving") {
                    UIApplication.shared.open(urlDestination)
                }
            }
        }))
        alertActions.append(UIAlertAction(title: "Buka dengan Maps", style: .default, handler: { action in
            let url = "http://maps.apple.com/maps?saddr=\(String(dLatitude)),\(String(dLongitude))"
            UIApplication.shared.open(URL(string:url)!)
        }))
        actionSheetAlert(sender, alertActions, "", "")
    }
    
    static func addKeychainData(itemKey: String, itemValue: String) throws {
        guard let valueData = itemValue.data(using: .utf8) else {
            print("Keychain: Unable to store data, invalid input - key: \(itemKey), value: \(itemValue)")
            return
        }

        //delete old value if stored first
        do {
            try deleteKeychainData(itemKey: itemKey)
        } catch {
            print("Keychain: nothing to delete...")
        }

        let queryAdd: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: itemKey as AnyObject,
            kSecValueData as String: valueData as AnyObject,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        let resultCode: OSStatus = SecItemAdd(queryAdd as CFDictionary, nil)

        if resultCode != 0 {
            print("Keychain: value not added - Error: \(resultCode)")
        } else {
            print("Keychain: value added successfully")
        }
    }

    static func deleteKeychainData(itemKey: String) throws {
        let queryDelete: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: itemKey as AnyObject
        ]

        let resultCodeDelete = SecItemDelete(queryDelete as CFDictionary)

        if resultCodeDelete != 0 {
            print("Keychain: unable to delete from keychain: \(resultCodeDelete)")
        } else {
            print("Keychain: successfully deleted item")
        }
    }

    static func queryKeychainData (itemKey: String) throws -> String? {
        let queryLoad: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: itemKey as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let resultCodeLoad = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(queryLoad as CFDictionary, UnsafeMutablePointer($0))
        }

        if resultCodeLoad != 0 {
            print("Keychain: unable to load data - \(resultCodeLoad)")
            return nil
        }

        guard let resultVal = result as? NSData, let keyValue = NSString(data: resultVal as Data, encoding: String.Encoding.utf8.rawValue) as String? else {
            print("Keychain: error parsing keychain result - \(resultCodeLoad)")
            return nil
        }
        return keyValue
    }
    
    static func getUUID() -> String? {
        let uuidKey = AppConfig.bundleIdentifier + ".UUID"
        if let uuid = try? MainHelper.queryKeychainData(itemKey: uuidKey) {
            return uuid
        }
        guard let newId = UIDevice.current.identifierForVendor?.uuidString else {
            return nil
        }
        try? MainHelper.addKeychainData(itemKey: uuidKey, itemValue: newId)
        return newId
    }
    
    static func registerNotification(){
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        UIApplication.shared.registerForRemoteNotifications()
    }
    
//    static func getSlider(url: String, defImg: UIImage, bgColor:UIColor, contentMode: UIImageView.ContentMode = .scaleAspectFill, rounded: Bool = false, bottom: CGFloat = 0) -> BannerSliderViewController {
//        let con         = MainHelper.instantiateVC(.mainStoryboard, "BannerSliderViewController") as! BannerSliderViewController
//        con.url                 = url
//        con.defImg              = defImg
//        con.contentMode         = contentMode
//        con.backgroundColor     = bgColor
//        con.rounded             = rounded
//        con.bottom              = bottom
//        return con
//    }
    
    static func downloadFile(sender: UIViewController, downloadLink: String, progressView: ProgressView){
        let linkParse       = downloadLink.split(separator: "/")
        let nameFile        = String(linkParse[(linkParse.count - 1)])
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL    = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL         = documentsURL.appendingPathComponent(nameFile)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        progressView.show(sender)
        Alamofire.download(downloadLink, to: destination).response { response in
            print(response)
            progressView.hide()
            if response.error == nil, let resFilePath = response.destinationURL?.path {
                let documento   = NSURL(fileURLWithPath: resFilePath)
                let activityViewController: UIActivityViewController                = UIActivityViewController(activityItems: [documento], applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView    = sender.view
                sender.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
    
    static func convertCLLocationDistanceToKiloMeters ( targetDistance : CLLocationDistance?) -> Int {
        let value = targetDistance!/1000
        return Int(value)
    }
    
    static func getDistanceAPI(cor1:String, _ cor2:String, completion: @escaping (_ status: Bool, _ distance: String)->()){
        var URL = "https://maps.googleapis.com/maps/api/directions/json?origin=" + cor1.replacingOccurrences(of: " ", with: "") + "&destination=" + cor2.replacingOccurrences(of: " ", with: "") + "&key=" + AppConfig.MAPS_API_KEY
        URL = URL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        Alamofire.request(URL, method: .post, parameters: nil).validate().responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.result.value {
                    if let resJSON = json as? [String:Any]{
                        if let routesArray = resJSON["routes"] as? Array<Any> {
                            if let routes = routesArray[0] as? [String:Any] {
                                if let legsArray = routes["legs"] as? Array<Any> {
                                    if let legs = legsArray[0] as? [String:Any] {
                                        if let durations = legs["distance"] as? [String:Any]{
                                            let text = durations["text"] as? String ?? "--"
                                            completion(true, text)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            case .failure(let error):
                print(error)
                AlertHelper.checkConn()
            }
        }
    }
    
    static func getLocationInfoByCoordinate(latlng:String, completion: @escaping (_ status: Bool, _ address: String)->()){
//        let parameters:Parameters      = [
//            "latlng"   : latlng,
//            "key"      : AppConfig.MAPS_API_KEY
//        ]
//
//        Alamofire.request(URLConfig.URL_GEOCODER, method: .get, parameters: parameters).responseString { response in
//            switch response.result {
//            case .success:
//                let res     = response.result.value!
//                let json    = JSON.init(parseJSON:res)
//                print(json)
//                if(json["status"].stringValue == .responseOK){
//                    if(json["results"].arrayValue.count > 0){
//                        let result      = json["results"][0]
//                        completion(true, result["formatted_address"].stringValue)
//                    }
//                }else{
//                    AlertHelper.failedMsg(msg: "Terjadi Kesalahan")
//                    completion(false, "")
//                }
//            case .failure(let error):
//                print(error)
//                AlertHelper.checkConn()
//                completion(false, "")
//            }
//        }
    }
    
    static func selectEnvironment(_ sender: UIViewController){
//        var actions = [UIAlertAction]()
//        actions.append(UIAlertAction(title: "Production", style: .default, handler: { action in
//            UserDefaults.standard.set("https://simanis.bumn.go.id/api/", forKey: "base_url")
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                exit(-1)
//            }
//
//        }))
//        actions.append(UIAlertAction(title: "Development", style: .default, handler: { action in
//            UserDefaults.standard.set("http://simanisdev.bumn.go.id/api/", forKey: "base_url")
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                exit(-1)
//            }
//        }))
//        actionSheetAlert(sender, actions, "Pilih environtment", "", false)
    }
    
    static func getFirstName(_ fullName: String) -> String {
        let components = fullName.split(separator: " ", maxSplits: 1).map(String.init)
        return components.first ?? ""
    }
    
    static func setTableview(sender: UIViewController, tableView: UITableView, _ withSeparator: Bool = false){
        tableView.dataSource            = sender as? UITableViewDataSource
        tableView.delegate              = sender as? UITableViewDelegate
        tableView.rowHeight             = UITableView.automaticDimension
        if(!withSeparator){
            tableView.separatorStyle    = .none
        }
        tableView.estimatedRowHeight    = 100
    }
    
    static func setTableview(sender: UIViewController, tableView: UITableView, selector: Selector, _ withSeparator: Bool = false){
        let refresher                   = UIRefreshControl()
        tableView.dataSource            = sender as? UITableViewDataSource
        tableView.delegate              = sender as? UITableViewDelegate
        tableView.rowHeight             = UITableView.automaticDimension
        tableView.estimatedRowHeight    = 100
        if(!withSeparator){
            tableView.separatorStyle    = .none
        }
        refresher.tintColor             = UIColor.gray
        refresher.addTarget(sender, action: selector, for: .valueChanged)
        tableView.addSubview(refresher)
        refresher.beginRefreshing()
    }
    
    static func endRefreshTable(tableView: UITableView){
        for v in tableView.subviews{
            if let refresher = v as? UIRefreshControl{
                if(refresher.isRefreshing){
                    refresher.endRefreshing()
                }
            }
        }
    }

}
