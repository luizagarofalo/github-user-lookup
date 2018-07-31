//
//  UserDetailsViewController.swift
//  github-user-lookup
//
//  Created by Luiza Collado Garofalo on 28/07/18.
//  Copyright © 2018 Luiza Garofalo. All rights reserved.
//

import SDWebImage
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
        setup()
    }

    private func setup() {
        self.repositoriesTableView.separatorInset = .zero
        self.usernameLabel.text = username
        self.userAvatar.layer.cornerRadius = 50
        self.userAvatar.clipsToBounds = true
        guard let avatar = self.repositories[0].owner?.avatarURL else { return }
        self.userAvatar.sd_setImage(with: URL(string: avatar),
                                    placeholderImage: UIImage(named: "placeholder.png"),
                                    options: .highPriority,
                                    completed: nil)

        repositoriesTableView.register(UINib(nibName: "RepositoryTableViewCell", bundle: nil),
                                       forCellReuseIdentifier: "cell")
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
