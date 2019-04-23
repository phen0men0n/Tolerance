//
//  ViewController.swift
//  Tolerance
//
//  Created by OLEG KALININ on 04.03.2019.
//  Copyright © 2019 oki. All rights reserved.
//

import UIKit
import CoreMotion


class ViewController: UIViewController, OKDispalyMotionDelegate {

    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var buttonDone: UIButton!
    
    @IBOutlet private weak var info1: UILabel!
    @IBOutlet private weak var info2: UILabel!
    @IBOutlet private weak var info3: UILabel!
    @IBOutlet private weak var info4: UILabel!
    
    @IBOutlet private weak var infoAccelX: UILabel!
    @IBOutlet private weak var infoAccelY: UILabel!
    @IBOutlet private weak var infoAccelZ: UILabel!
    
    @IBOutlet private weak var infoGyroX: UILabel!
    @IBOutlet private weak var infoGyroY: UILabel!
    @IBOutlet private weak var infoGyroZ: UILabel!
    
    @IBOutlet private weak var infoMAttitudeRoll: UILabel!
    @IBOutlet private weak var infoMAttitudePitch: UILabel!
    @IBOutlet private weak var infoMAttitudeYaw: UILabel!
    
    @IBOutlet private weak var infoMRotationRateX: UILabel!
    @IBOutlet private weak var infoMRotationRateY: UILabel!
    @IBOutlet private weak var infoMRotationRateZ: UILabel!
    
    @IBOutlet private weak var infoMUserAccelX: UILabel!
    @IBOutlet private weak var infoMUserAccelY: UILabel!
    @IBOutlet private weak var infoMUserAccelZ: UILabel!
    
    @IBOutlet private weak var infoMGravityX: UILabel!
    @IBOutlet private weak var infoMGravityY: UILabel!
    @IBOutlet private weak var infoMGravityZ: UILabel!
    
    @IBOutlet private weak var infoRadius: UILabel!
    @IBOutlet private weak var infoRadiusTolerance: UILabel!
    @IBOutlet private weak var infoForce: UILabel!
    
    let application: OKApplication! = UIApplication.shared as? OKApplication
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.infoRadius.text = " "
        self.infoRadiusTolerance.text = " "
        self.infoForce.text = " "
        self.textField.isEnabled = false
        self.buttonDone.isEnabled = false
        
        DataManager.shared.registerUser { (_ json, error) in
            if let _ = error {
                let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert);
                self.present(alert, animated: true, completion: nil);
                
            } else {
                self.textField.isEnabled = true
                self.buttonDone.isEnabled = true
                self.info1.text = "USER NAME: \(DataManager.shared.user ?? "!no user name!")"
                self.info2.text = "USER PASS: \(DataManager.shared.pass ?? "!no user pass!")"
                self.info3.text = "DEVICE ID: \(DataManager.shared.deviceId)"
                if let _json = json,
                    let _cnt = _json["total sessions by user and device"].string {
                        self.info4.text = "Отправлено: [\(_cnt)]"

                } else {
                    self.info4.text = " "
                }
            }
        }
        
        application.displayDelegate = self
    }

    @IBAction func buttonDone(_ sender: Any) {
        if let pass = textField.text {
            if pass == DataManager.shared.pass {
                DataManager.shared.sendData { (response) in
                    print("send data")
                    self.textField.resignFirstResponder()
                    self.textField.text = nil
                    if let response = response {
                        self.info4.text = "Отправлено: [\(response["total sessions by user and device"])]"
                    } else {
                        self.info4.text = "Ошибка"
                    }
                }
            } else {
                alertPass()
            }
        } else {
            alertPass()
        }
    }

    func alertPass() {
        let alert = UIAlertController(title: "Error", message: "Неверный пароль", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { (action) in
            //
        }))
        show(alert, sender: nil)
    }
    
    // MARK: - OKDispalyMotionDelegate -
    func displayMotion(accelerator: CMAccelerometerData, gyro: CMGyroData, motion: CMDeviceMotion) {
        DispatchQueue.main.async {
            self.infoAccelX.text = String(format: "%.4f", accelerator.acceleration.x);
            self.infoAccelY.text = String(format: "%.4f", accelerator.acceleration.y);
            self.infoAccelZ.text = String(format: "%.4f", accelerator.acceleration.z);
            
            self.infoGyroX.text = String(format: "%.4f", gyro.rotationRate.x);
            self.infoGyroY.text = String(format: "%.4f", gyro.rotationRate.y);
            self.infoGyroZ.text = String(format: "%.4f", gyro.rotationRate.z);
            
            self.infoMAttitudeRoll.text = String(format: "%.4f", motion.attitude.roll);
            self.infoMAttitudePitch.text = String(format: "%.4f", motion.attitude.pitch);
            self.infoMAttitudeYaw.text = String(format: "%.4f", motion.attitude.yaw);
            
            self.infoMRotationRateX.text = String(format: "%.4f", motion.rotationRate.x);
            self.infoMRotationRateY.text = String(format: "%.4f", motion.rotationRate.y);
            self.infoMRotationRateZ.text = String(format: "%.4f", motion.rotationRate.z);
            
            self.infoMUserAccelX.text = String(format: "%.4f", motion.userAcceleration.x);
            self.infoMUserAccelY.text = String(format: "%.4f", motion.userAcceleration.y);
            self.infoMUserAccelZ.text = String(format: "%.4f", motion.userAcceleration.z);
            
            self.infoMGravityX.text = String(format: "%.4f", motion.gravity.x);
            self.infoMGravityY.text = String(format: "%.4f", motion.gravity.y);
            self.infoMGravityZ.text = String(format: "%.4f", motion.gravity.z);
            
        }
        
    }
    
    func displayTouch(touch: UITouch) {
        DispatchQueue.main.async {
            if touch.phase == .ended {
                self.infoRadius.text = " ";
                self.infoRadiusTolerance.text = " ";
                self.infoForce.text = " ";
            } else {
                self.infoRadius.text = String(format: "%.4f", touch.majorRadius);
                self.infoRadiusTolerance.text = String(format: "%.4f", touch.majorRadiusTolerance);
                self.infoForce.text = String(format: "%.4f", touch.force);
            }
        }
    }
}

