//
//  UserDetailsViewController.swift
//  github-user-lookup
//
//  Created by Luiza Collado Garofalo on 28/07/18.
//  Copyright © 2018 Luiza Garofalo. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet private weak var userAvatar: UIImageView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var repositoriesTableView: UITableView!

    var username = ""
    var repositories: [Repository] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.repositoriesTableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameLabel.text = username

        repositoriesTableView.register(UINib(nibName: "RepositoryTableViewCell", bundle: nil),
                                       forCellReuseIdentifier: "cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                       for: indexPath) as? RepositoryTableViewCell else {
                                                        return UITableViewCell()
        }

        cell.repositoryTitle.text = self.repositories[indexPath.row].name
        cell.repositorySubtitle.text = self.repositories[indexPath.row].language

        return cell
    }
}
