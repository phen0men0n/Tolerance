//
//  SettingsViewController.swift
//  Tolerance
//
//  Created by OLEG KALININ on 24/05/2019.
//  Copyright © 2019 oki. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    @IBOutlet private weak var labelFreq: UILabel!
    @IBOutlet private weak var stepper: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView();
        stepper.value = Double(Settings.shared.accelFreq);
        
        update()
    }
    
    private func update() {
        labelFreq.text = "\(Settings.shared.accelFreq)";
    }
    
    @IBAction func stepper(_ sender: UIStepper) {
        
        Settings.shared.accelFreq = Int(sender.value)
        update()
        //labelFreq.text = "\(sender.value)";
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
