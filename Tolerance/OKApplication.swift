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

class OKApplication: UIApplication {
    
    private var motionManager: CMMotionManager!
    private var motionTimer: Timer!
    
    public weak var atomDelegate: OKApplicationDelegate?
    
    override init() {
        super.init()
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        motionTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(motionTimerFire(_:)), userInfo: nil, repeats: true)
    }
    
    deinit {
        motionTimer.invalidate()
        motionManager.stopAccelerometerUpdates()
    
    }
    
    @objc func motionTimerFire(_ timer: Timer) {
        if let accelerometerData = motionManager.accelerometerData {
            DataManager.shared.addAtom(Atom(touch: nil, accelerometer: accelerometerData))
        }
    }
    
    override func sendEvent(_ event: UIEvent) {
        
        if let touches = event.allTouches {
            for touch in touches {
                
                
                DispatchQueue.global().async {
                    let atom = Atom(touch: touch, accelerometer: self.motionManager.accelerometerData)
                    DataManager.shared.atoms.append(atom);
                }
                
            }
        }
        super.sendEvent(event)
    }
    
}
