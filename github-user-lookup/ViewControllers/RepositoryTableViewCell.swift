import UIKit

class RepositoryTableViewCell: UITableViewCell {
    @IBOutlet weak var repositoryTitle: UILabel!
    @IBOutlet weak var repositorySubtitle: UILabel!
    @IBOutlet weak var view: UIView!

    override func layoutSubviews() {
        self.view.roundCorners([.topLeft, .topRight], radius: 8.0)
        self.view.layer.masksToBounds = false
        self.view.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.view.layer.shadowColor = UIColor.black.cgColor
        self.view.layer.shadowOpacity = 0.05
        self.view.layer.shadowRadius = 3
    }
}
