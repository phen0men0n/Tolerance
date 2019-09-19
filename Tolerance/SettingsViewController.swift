//
//  SettingsViewController.swift
//  Tolerance
//
//  Created by OLEG KALININ on 24/05/2019.
//  Copyright © 2019 oki. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet private weak var labelFreq: UILabel!
    @IBOutlet private weak var stepper: UIStepper!
    @IBOutlet private weak var server: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView();
        stepper.value = Double(Settings.shared.accelFreq);
        
        update()
    }
    
    private func update() {
        labelFreq.text = "\(Settings.shared.accelFreq)";
        server.text = Settings.shared.serverIp;
    }
    
    @IBAction func stepper(_ sender: UIStepper) {
        
        Settings.shared.accelFreq = Int(sender.value)
        update()
        //labelFreq.text = "\(sender.value)";
    }

    // MARK: - UITextFieldDelegate
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        Settings.shared.serverIp = textField.text;
        return true;
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
