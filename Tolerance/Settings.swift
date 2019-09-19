//
//  Settings.swift
//  Tolerance
//
//  Created by OLEG KALININ on 24/05/2019.
//  Copyright © 2019 oki. All rights reserved.
//

import UIKit

private struct Static {
    static let accelFreq = "accelFreq"
    static let serverIP = "serverIp"
}

class Settings: NSObject {

    static let shared = Settings()
    static let settingsChangedNotification = "settingsChangedNotification"
    
    var accelFreq: Int {
        get {
            let freq = UserDefaults.standard.integer(forKey: Static.accelFreq);
            return freq
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: Static.accelFreq);
            NotificationCenter.default.post(name: Notification.Name(Settings.settingsChangedNotification), object: nil)
        }
    }
    
    var serverIp: String? {
        get {
            let ip = UserDefaults.standard.string(forKey: Static.serverIP);
            return ip
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: Static.serverIP);
            NotificationCenter.default.post(name: Notification.Name(Settings.settingsChangedNotification), object: nil)
        }
    }
}
