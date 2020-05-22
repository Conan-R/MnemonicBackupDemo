//
//  ViewController.swift
//  RLMnemonicBackupDemo
//
//  Created by iOS on 2020/5/22.
//  Copyright © 2020 beiduofen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let backupController = RLMnemonicBackupController()
        navigationController?.pushViewController(backupController, animated: true)
    }

}

