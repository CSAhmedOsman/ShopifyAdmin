//
//  AddProductViewController.swift
//  SwiftCart Admin
//
//  Created by Mac on 17/06/2024.
//

import UIKit

class AddProductViewController: UIViewController {

    @IBOutlet weak var tfProductName: UITextField!
    @IBOutlet weak var tfImageURL: UITextField!
    
    @IBOutlet weak var vendorButton: UIButton!
    @IBOutlet weak var productTypeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupVendorButton()
        setupProductTypeButton()
    }
    
    func setupProductTypeButton(){
        let menuItems = [
            UIAction(title: "Option 1", handler: { _ in self.optionSelected("Option 1") }),
            UIAction(title: "Option 2", handler: { _ in self.optionSelected("Option 2") }),
            UIAction(title: "Option 3", handler: { _ in self.optionSelected("Option 3") })
        ]
        let vendorMenu = UIMenu(title: "Options", children: menuItems)
        
        productTypeButton.menu = vendorMenu
        productTypeButton.showsMenuAsPrimaryAction = true
    }
    
    private func setupVendorButton() {
        let menuItems = [
            UIAction(title: "Option 1", handler: { _ in self.optionSelected("Option 1") }),
            UIAction(title: "Option 2", handler: { _ in self.optionSelected("Option 2") }),
            UIAction(title: "Option 3", handler: { _ in self.optionSelected("Option 3") })
        ]
        let vendorMenu = UIMenu(title: "Options", children: menuItems)
        
        vendorButton.menu = vendorMenu
        vendorButton.showsMenuAsPrimaryAction = true
    }
    
    private func optionSelected(_ option: String) {
        print("Selected: \(option)")
        vendorButton.setTitle(option, for: .normal)
    }

}
