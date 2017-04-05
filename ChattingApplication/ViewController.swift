//
//  ViewController.swift
//  ChattingApplication
//
//  Created by XINHAO LI on 4/5/17.
//  Copyright © 2017 XINHAO LI. All rights reserved.
//

import UIKit
import Firebase
class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let ref = FIRDatabase.database().reference(fromURL: "https://chattingapplication-86079.firebaseio.com/")
//        ref.updateChildValues(["someValue": 123123])
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    }
    
    func handleLogout() {
        let loginController = LoginViewController()
        present(loginController, animated: true, completion: nil)
    }

}

