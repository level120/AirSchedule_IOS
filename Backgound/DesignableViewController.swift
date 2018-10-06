//
//  DesignableViewController.swift
//  AirSchedule_IOS
//
//  Created by Chenny on 06/10/2018.
//  Copyright © 2018  Gusam Park. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableViewController: UIViewController {
    
    @IBInspectable var LightStatusBar: Bool = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            if LightStatusBar {
                return UIStatusBarStyle.lightContent
            } else {
                return UIStatusBarStyle.default
            }
        }
    }
}
