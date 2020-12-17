//
//  AlertHelper.swift
//  Simanis
//
//  Created by GADA-63 on 28/04/20.
//  Copyright © 2020 Simanis. All rights reserved.
//

import Foundation
import UIKit
import SwiftMessages

class AlertHelper {
    
    static func failedMsg(msg: String){
        let view = MessageView.viewFromNib(layout: .messageView)
        view.configureTheme(.error)
        view.backgroundColor    = UIColor(hex: "C2185B")
        view.button?.isHidden   = true
//        view.titleLabel?.isHidden = true
        view.configureContent(title: "Gagal", body: msg)
        SwiftMessages.show(view: view)
    }
    
    static func successMsg(msg: String){
        let view = MessageView.viewFromNib(layout: .messageView)
        view.configureTheme(.success)
        view.button?.isHidden = true
//        view.titleLabel?.isHidden = true
        view.configureContent(title: "Berhasil", body: msg)
        SwiftMessages.show(view: view)
    }
    
    static func infoMsg(msg: String){
        let view = MessageView.viewFromNib(layout: .messageView)
        view.configureTheme(.info)
        view.button?.isHidden = true
        view.titleLabel?.isHidden = true
        view.configureContent(body: msg)
        var config = SwiftMessages.Config()
        config.duration = .seconds(seconds: 10)
        SwiftMessages.show(config: config, view: view)
    }
    
    static func checkConn(){
        let view = MessageView.viewFromNib(layout: .statusLine)
        view.configureTheme(.error)
        view.configureContent(body: "Tidak dapat terhubung")
        SwiftMessages.show(view: view)
    }
    
    static func noConn(){
        let view = MessageView.viewFromNib(layout: .statusLine)
        view.configureTheme(.error)
        view.configureContent(body: "Tidak dapat terhubung")
        SwiftMessages.show(view: view)
    }
    
    static func errJson(){
        let view = MessageView.viewFromNib(layout: .statusLine)
        view.configureTheme(.error)
        view.configureContent(body: "Terjadi Kesalahan")
        SwiftMessages.show(view: view)
    }
    
    public static func simpleAlert(sender: UIViewController, title: String, desc: String, okBtn: String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: desc, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: okBtn, style: UIAlertAction.Style.default, handler: nil))
            sender.present(alert, animated: true, completion: nil)
        }
    }
    
    public static func notifMsg(userInfo: [AnyHashable:Any], action: @escaping () -> Void){
        let view    = MessageView.viewFromNib(layout: .cardView)
        var title   = ""
        var body    = ""
        var config = SwiftMessages.Config()
        
        if let aps = userInfo["aps"] as? NSDictionary {
            if let alert    = aps["alert"] as? NSDictionary {
                if let alertTitle = alert["title"] as? String {
                    title   = alertTitle
                }
                if let alertMessage = alert["body"] as? String {
                    body    = alertMessage
                }
            }
        }
        
        view.configureTheme(.info)
        view.button?.isHidden = true
        view.configureContent(title: title, body: body)
        view.tapHandler = { _ in
            action()
            SwiftMessages.hide()
        }
        
        config.duration = .seconds(seconds: 5)
        SwiftMessages.show(config: config, view: view)
    }
    
}
