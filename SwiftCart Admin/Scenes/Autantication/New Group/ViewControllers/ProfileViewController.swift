//
//  ProfileViewController.swift
//  SwiftCart Admin
//
//  Created by Mac on 25/06/2024.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    weak var coordinator: AppCoordinator?
    
    @IBOutlet weak var dataTable: UITableView!
    
    private let data = ["About Us", "Contact Us"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataTable.delegate = self
        dataTable.dataSource = self
    }
    
    @IBAction func logout(_ sender: UIButton) {
        let okBtn = UIAlertAction(title: "OK", style: .default) { _ in
            do {
                try Auth.auth().signOut()
                self.coordinator?.logout()
            } catch let signOutError {
                print("Error signing out: %@", signOutError)
                Utils.showAlert(title: "Error!", message: "soory somethign went roung pleas try again later \n \(signOutError.localizedDescription)", preferredStyle: .alert, from: self)
            }
        }
        
        Utils.showAlert(title: "Logout", message: "You are about to logout.", preferredStyle: .alert, from: self, actions: [okBtn, UIAlertAction(title: "Cancel", style: .cancel)])
    }
}


extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CustomView.defaultCellIdentifier, for: indexPath)
    
        cell.textLabel?.text = data[indexPath.item]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.item{
        case 0:
            coordinator?.gotoAboutUs()
        case 1:
            coordinator?.gotoContactUs()
        default:
            break
        }
    }
}
