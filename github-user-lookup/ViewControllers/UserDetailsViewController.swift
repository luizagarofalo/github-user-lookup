//
//  UserDetailsViewController.swift
//  github-user-lookup
//
//  Created by Luiza Collado Garofalo on 28/07/18.
//  Copyright © 2018 Luiza Garofalo. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var repositoriesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        repositoriesTableView.register(UINib(nibName: "RepositoryTableViewCell", bundle: nil),
                                       forCellReuseIdentifier: "cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RepositoryTableViewCell else { return UITableViewCell() }
    
        return cell
    }
}
