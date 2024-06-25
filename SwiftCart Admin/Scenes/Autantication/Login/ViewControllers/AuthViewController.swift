//
//  ViewController.swift
//  SwiftCart
//
//  Created by Mac on 30/05/2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class AuthViewController: UIViewController {
    weak var coordinator: AppCoordinator?
    var viewModel: AuthViewModel!

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func login(sender: UIButton) {

        sender.configuration?.showsActivityIndicator = true
        sender.isEnabled = false
        
        viewModel.login(email: email.text ?? "", password: password.text ?? "") { [weak self] result in
            switch result{
            case .success(_):
                DispatchQueue.main.async {
                    self?.email.text = ""
                    self?.password.text = ""
                    self?.coordinator?.gotoHome()
                }
            case .failure(let error):
                guard let self else{ break }
                Utils.showAlert(title: "Login", message: error.localizedDescription, preferredStyle: .alert, from: self)
            }
            sender.configuration?.showsActivityIndicator = false
            sender.isEnabled = true
        }
    }
}
