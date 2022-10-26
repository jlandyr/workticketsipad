//
//  ViewController.swift
//  WorkTicket
//
//  Created by Juan Landy on 24/10/22.
//

import UIKit

final class LoginViewController: UIViewController {

    //MARK: UI
    @IBOutlet weak var textUserName: DesignableUITextField!{
        didSet{
            textUserName.delegate = self
        }
    }
    @IBOutlet weak var textPassword: DesignableUITextField!{
        didSet{
            textPassword.delegate = self
        }
    }
    
    //MARK: ViewModel
    private lazy var viewModel = LoginViewModel()
    
    //MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setKeyboardNotifications()
    }
    
    //MARK: - Login
    @IBAction func didSelectLogin(_ sender: UIButton) {
        if let userName = textUserName.text, !userName.isEmpty, let password = textPassword.text, !password.isEmpty {
            viewModel.validateUser(withUserName: userName, password: password) { [weak self] result in
                guard let self = self else {return}
                switch result {
                case .failure(let error): self.showAlert(title: "error", message: error.localizedDescription)
                case .success(): self.navigateToDashboard(withUser: userName)
                }
            }
        }
    }
    
}

