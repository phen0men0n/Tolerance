//
//  TestFraudViewController.swift
//  Tolerance
//
//  Created by OLEG KALININ on 12.09.2019.
//  Copyright © 2019 oki. All rights reserved.
//

import UIKit

class TestFraudViewController: UIViewController {

    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var buttonDone: UIButton!
    @IBOutlet private weak var viewRed: UIView!
    
    var isFraud: Bool? {
        didSet {
            if let val = isFraud {
                viewRed.backgroundColor = !val ? UIColor.red : UIColor.green;
                //viewGreen.alpha = val ? 1:0.05
                //viewRed.isHidden = !val;
                //viewGreen.isHidden = val;
            } else {
                viewRed.backgroundColor = UIColor.clear;
                
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewRed.backgroundColor = UIColor.clear;
        
        DataManager.shared.clear();
    }
    
    @IBAction func buttonDone(_ sender: Any) {
        if let pass = textField.text {
            if pass == "936492" {
                DataManager.shared.toleranceIdentityChecker(completion: { (json, error) in
                    
                    if let _ = error {
                        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        
                        print("send data")
                        self.textField.resignFirstResponder()
                        self.textField.text = nil
                        
                        if let _json = json,
                            let fraudAlert = _json["fraud_alert"].string,
                            let _ = _json["session_id"].string {
                            
                            self.isFraud = fraudAlert == "True";
                        }
                        
                    }

                })
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
        self.present(alert, animated: true, completion: nil)
    }
}
