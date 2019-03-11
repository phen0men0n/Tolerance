//
//  ViewController.swift
//  Tolerance
//
//  Created by OLEG KALININ on 04.03.2019.
//  Copyright © 2019 oki. All rights reserved.
//

import UIKit



class ViewController: UIViewController {

    @IBOutlet private weak var info1: UILabel!
    @IBOutlet private weak var info2: UILabel!
    @IBOutlet private weak var info3: UILabel!
    @IBOutlet private weak var textField: UITextField!
    
    let application: OKApplication! = UIApplication.shared as? OKApplication
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        info1.text = "USER NAME: \(DataManager.shared.user ?? "!no user name!")"
        info2.text = "USER PASS: \(DataManager.shared.pass ?? "!no user pass!")"
        info3.text = "DEVICE ID: \(DataManager.shared.deviceId)"
    }

    @IBAction func buttonDone(_ sender: Any) {
        if let pass = textField.text {
            if pass == DataManager.shared.pass {
                DataManager.shared.sendData {
                    print("send data")
                    self.textField.resignFirstResponder()
                    self.textField.text = nil
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
}

