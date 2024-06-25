//
//  ProfileViewController.swift
//  SwiftCart Admin
//
//  Created by Mac on 25/06/2024.
//

import UIKit

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
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: K.Enums.Auth.userStatus)

        coordinator?.logout()
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
