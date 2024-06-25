//
//  EditQuntatyViewController.swift
//  SwiftCart Admin
//
//  Created by Mac on 24/06/2024.
//

import UIKit

class EditQuntatyViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lbValue: UILabel!
    @IBOutlet weak var lbOrValue: UILabel!

    var bindDataToInventoryScreen: (Int) -> () = {_ in }
    
    var value = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lbValue.text = "\(value)"
        lbOrValue.text = "Original: \(value)"
        mainView.layer.cornerRadius = 16
    }
    
    @IBAction func add(_ sender: UIButton) {
        switch sender.tag{
        case 1:
            if value < 50{
                value += 1
            }else{
                Utils.showAlert(title: "Value", message: "Are you sure to let the value bigger than 50?", preferredStyle: .alert, from: self,actions: [UIAlertAction(title: "Yes", style: .default, handler: { _ in
                    self.value += 1
                }),UIAlertAction(title: "Cancel", style: .cancel)])
            }
        case 2:
            if value > 0{
                value -= 1
            }
        default:
            break
        }
        lbValue.text = "\(value)"
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        if sender.tag == 5{
            bindDataToInventoryScreen(value)
        }
        
        self.dismiss(animated: true)
    }
    
}
