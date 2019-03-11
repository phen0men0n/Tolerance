//
//  Atom.swift
//  Tolerance
//
//  Created by OLEG KALININ on 06.03.2019.
//  Copyright © 2019 oki. All rights reserved.
//

import UIKit
import CoreMotion
import SceneKit

private struct Static {
    static var tagTextField = 10
    static var tagMainView = 11
    static var tagButtonDone = 12
}

class Atom: NSObject {
    
    var accelerometerData: CMAccelerometerData?
    var accelerometerTimestamp: TimeInterval?
    var brightness: CGFloat?
    
    var phase: String?
    var timestamp: TimeInterval?
    var majorRadius: CGFloat?
    var majorRadiusTolerance: CGFloat?
    var force: CGFloat?
    var source: UIView?
    var location: CGPoint?
    
    var json: [String : Any] {
        get {
            
            var touch: [String:Any] = [:]
            touch["timestamp"] = timestamp
            touch["majorRadius"] = majorRadius
            touch["majorRadiusTolerance"] = majorRadiusTolerance
            touch["force"] = force
            touch["phase"] = phase
            
            var sourceView: [String:Any] = [:]
            switch source?.tag {
            case Static.tagTextField:
                sourceView["name"] = "textField"
            case Static.tagMainView:
                sourceView["name"] = "mainView"
            case Static.tagButtonDone:
                sourceView["name"] = "buttonDone"
            default:
                break
            }
            
            if let _ = sourceView["name"] {
                sourceView["location"] = ["x":location?.x, "y":location?.y]
                sourceView["position"] = ["origin": ["x":source?.frame.origin.x, "y":source?.frame.origin.y],
                                          "size":   ["width":source?.frame.size.width, "height":source?.frame.size.height]]
                
                touch["source"] = sourceView
            }
            
            var retVal: [String:Any] = [:]
            retVal["touch"] = touch
            
            
            if let accelerometerData = accelerometerData {
                retVal["accelerometer"] = accelerometerData.json(timestamp: accelerometerTimestamp)
                retVal["brightness"] = brightness
            }
            
            
            
            return retVal
        }
    }
    
    init(touch t: UITouch?, accelerometer: CMAccelerometerData?) {
        super.init()
        accelerometerData = accelerometer
        accelerometerTimestamp = ProcessInfo.processInfo.systemUptime;
        brightness = UIScreen.main.brightness
        if let _t = t {
            switch _t.phase {
            case .began:
                phase = "began"
            case .ended:
                phase = "ended"
            case .moved:
                phase = "moved"
            case .stationary:
                phase = "stationary"
            case .cancelled:
                phase = "cancelled"
            }
            
            timestamp = _t.timestamp
            majorRadius = _t.majorRadius
            majorRadiusTolerance = _t.majorRadiusTolerance
            force = _t.force
            source = _t.view
            location = _t.location(in: _t.view)
            
        }
        
    }
    
}

extension CMAccelerometerData {
    
    public var json: [String:Any] {
        get {
            var retVal: [String:Any] = [:]
            
            retVal["x"] = acceleration.x
            retVal["y"] = acceleration.y
            retVal["z"] = acceleration.z
            
            return retVal
        }
    }
    
    func json(timestamp ti:TimeInterval?) -> [String: Any] {
        var retVal: [String:Any] = [:]
        
        retVal["x"] = acceleration.x
        retVal["y"] = acceleration.y
        retVal["z"] = acceleration.z
        
        guard let _ = ti else { return retVal}
        
        retVal["timestamp"] = ti
        
        return retVal
    }
}
