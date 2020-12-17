//
//  ProgressView.swift
//  Simanis
//
//  Created by GADA-63 on 28/04/20.
//  Copyright © 2020 Simanis. All rights reserved.
//

import Foundation
import UIKit
import JGProgressHUD

class ProgressView: JGProgressHUD {
    
    var hud:JGProgressHUD!
    
    init(msg: String = "") {
        hud                     = ProgressView.checkIfUserInDarkMode()
        hud.textLabel.text      = msg
        super.init(style: .light)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }
    
    public func show(_ sender: UIViewController) {
        hud.show(in: sender.view)
    }
    
    public func show(_ sender: UIViewController, _ msg: String) {
        hud.textLabel.text  = msg
        hud.show(in: sender.view)
    }
    
    public func showProgress(sender: UIViewController, totalFile:Int) {
        hud.indicatorView   = JGProgressHUDPieIndicatorView()
        hud.textLabel.text  = "Mengunggah " + String(totalFile) + " file"
        hud.progress        = 0.0
        hud.show(in: sender.view)
    }
    
    public func updateProgress(_ progress:Float){
        hud.progress        = progress
    }
    
    public func hide() {
        hud.dismiss()
    }
    
    static func checkIfUserInDarkMode() ->  JGProgressHUD {
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                return  JGProgressHUD(style: .dark)
            }
            else {
              return  JGProgressHUD(style: .extraLight)
            }
        }else{
           return JGProgressHUD(style: .extraLight)
        }
    }
}
