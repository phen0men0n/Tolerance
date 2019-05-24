//
//  OKApplication.swift
//  Tolerance
//
//  Created by OLEG KALININ on 04.03.2019.
//  Copyright © 2019 oki. All rights reserved.
//

import UIKit
import CoreMotion
import SceneKit

protocol OKApplicationDelegate: class {
    func newAtomData(atomData data:Atom) -> Void
}

protocol OKDispalyMotionDelegate: class {
    func displayMotion(accelerator: CMAccelerometerData, gyro: CMGyroData, motion: CMDeviceMotion) -> Void
    func displayTouch(touch: UITouch) -> Void
}

class OKApplication: UIApplication {
    
    private var motionManager: CMMotionManager!
    private var motionTimer: Timer!
    private var displayTimer: Timer!
    
    public weak var atomDelegate: OKApplicationDelegate?
    public weak var displayDelegate: OKDispalyMotionDelegate?
    
    override init() {
        super.init()
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        motionManager.startGyroUpdates()
        motionManager.startDeviceMotionUpdates()
        
        initMotionTimer()
        
        displayTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(displayTimerFire(_:)), userInfo: nil, repeats: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(settingsChanged(_:)), name: Notification.Name(Settings.settingsChangedNotification), object: nil)
    }
    
    deinit {
        motionTimer.invalidate()
        displayTimer.invalidate()
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
        motionManager.stopDeviceMotionUpdates()
    }
    
    private func initMotionTimer() {
    
        let ti = TimeInterval(1 / Double(Settings.shared.accelFreq == 0 ? 1:Settings.shared.accelFreq))
        if motionTimer != nil {
            motionTimer.invalidate()
        }
        motionTimer = Timer.scheduledTimer(timeInterval: ti,
                                           target: self,
                                           selector: #selector(motionTimerFire(_:)),
                                           userInfo: nil, repeats: true)
    }
    
    @objc func motionTimerFire(_ timer: Timer) {
        if let accelerometerData = motionManager.accelerometerData, let gyroData = motionManager.gyroData, let deviceMotion = motionManager.deviceMotion {
            
            DataManager.shared.addAtom(Atom(touch: nil,
                                            accelerometer: accelerometerData,
                                            gyro: gyroData,
                                            motion: deviceMotion))
        }
        print("fire")
        
    }
    
    @objc func displayTimerFire(_ timer: Timer) {
        if let accelerometerData = motionManager.accelerometerData,
            let gyroData = motionManager.gyroData,
            let deviceMotion = motionManager.deviceMotion,
            let delegate = self.displayDelegate {
            
            delegate.displayMotion(accelerator: accelerometerData, gyro: gyroData, motion: deviceMotion)
        }
    }
    
    @objc func settingsChanged(_ notify:Notification) {
        initMotionTimer()
    }
    
    override func sendEvent(_ event: UIEvent) {
        
        if let touches = event.allTouches {
            for touch in touches {
         
                let atom = Atom(touch: touch,
                                accelerometer: self.motionManager.accelerometerData,
                                gyro: self.motionManager.gyroData,
                                motion: self.motionManager.deviceMotion)
                
                DataManager.shared.atoms.append(atom);
                if let delegate = self.displayDelegate {
                    delegate.displayTouch(touch: touch)
                }
            }
        }
        super.sendEvent(event)
    }
    
}
