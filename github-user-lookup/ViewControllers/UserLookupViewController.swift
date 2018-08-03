import UIKit

class UserLookupViewController: UIViewController {
    @IBOutlet weak private var searchTextField: UITextField!
    private var repositories: [Repository] = []

    @IBAction private func search(_ sender: UIButton) {
        guard let username = searchTextField.text else { return }
        RequestNetworkGateway.load(username: username) { (result: Result) in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "userDetailsSegue", sender: user)
                }

            case .failure(.networkError):
                DispatchQueue.main.async {
                    ErrorMessage.show(title: "Oops!",
                                      message: "A network error has occured. " +
                        "Please, check your internet connection and try again later.",
                                      controller: self)
                }

            case .failure(.userNotFound):
                DispatchQueue.main.async {
                    ErrorMessage.show(title: "Oops!",
                                      message: "User not found. Please, enter another username.",
                                      controller: self)
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? UserDetailsViewController {
            if let repositories = sender as? [Repository] {
                viewController.username = (repositories[0].owner?.login)!
                viewController.repositories = repositories
            }
        }
    }
}
