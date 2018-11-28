import UIKit

class UserLookupViewController: UIViewController {
    @IBOutlet weak private var searchTextField: UITextField!
    @IBOutlet weak var searchButton: TransitionButton!
    private var repositories: [Repository] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true

        searchButton.cornerRadius = 20
        searchButton.spinnerColor = .white

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(UserLookupViewController.keyboardWillAppear),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(UserLookupViewController.keyboardWillDisappear),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardWillShow,
                                                  object: self.view.window)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardWillHide,
                                                  object: self.view.window)
    }

    @IBAction private func search(_ sender: UIButton) {
        self.hideKeyboard()
        searchButton.startAnimation()

        guard let username = searchTextField.text else { return }
        RequestNetworkGateway.load(username: username) { (result: Result) in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.searchButton.stopAnimation(animationStyle: .expand, completion: {
                        self.performSegue(withIdentifier: "userDetailsSegue", sender: user)
                    })
                }

            case .failure(.networkError):
                DispatchQueue.main.async {
                    self.searchButton.stopAnimation(animationStyle: .shake, completion: {
                        ErrorMessage.show(title: "Oops!",
                                          message: "A network error has occured. " +
                            "Please, check your internet connection and try again later.",
                                          controller: self)
                    })
                }

            case .failure(.userNotFound):
                DispatchQueue.main.async {
                    self.searchButton.stopAnimation(animationStyle: .shake, completion: {
                        ErrorMessage.show(title: "Oops!",
                                          message: "User not found. Please, enter another username.",
                                          controller: self)
                    })
                }
            }
        }
    }

    @objc func keyboardWillAppear(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= (keyboardSize.height / 2)
            }
        }
    }

    @objc func keyboardWillDisappear(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += (keyboardSize.height / 2)
            }
        }
    }

    func hideKeyboard() {
        self.searchTextField.resignFirstResponder()
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
