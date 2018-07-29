//
//  UserLookupViewController.swift
//  github-user-lookup
//
//  Created by Luiza Collado Garofalo on 28/07/18.
//  Copyright © 2018 Luiza Garofalo. All rights reserved.
//

import UIKit

class UserLookupViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    private var repositories: [Repository] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func search(_ sender: UIButton) {
        guard let username = searchTextField.text else { return }
        RequestNetworkGateway.load(username: username) { (user: [Repository]) in
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "userDetailsSegue", sender: user)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? UserDetailsViewController {
            if let user = sender as? [Repository] {
                viewController.username = (user[0].owner?.login)!
                viewController.repositories = user
            }
        }
    }
}
