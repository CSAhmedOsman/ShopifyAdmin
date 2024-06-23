//
//  AddProductViewController.swift
//  SwiftCart Admin
//
//  Created by Mac on 17/06/2024.
//

import UIKit
import RxSwift
import RxCocoa

class AddProductViewController: UIViewController {

    weak var coordinator: AppCoordinator?
    var viewModel: ProductViewModel!
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var tfProductName: UITextField!
    @IBOutlet weak var tfImageURL: UITextField!
    
    @IBOutlet weak var vendorButton: UIButton!
    @IBOutlet weak var productTypeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupMenuButton(options: K.Arrays.vendors, for: vendorButton)
        setupMenuButton(options: K.Arrays.productTypes, for: productTypeButton)
    }
    
    private func setupMenuButton(options: [String], for button: UIButton) {
        let menuItems = options.map { option in
            UIAction(title: option) { _ in
                button.setTitle(option, for: .normal)
            }
        }
        
        let menu = UIMenu(title: button.titleLabel?.text ?? "Options", children: menuItems)
        
        button.menu = menu
        button.showsMenuAsPrimaryAction = true
    }
}
