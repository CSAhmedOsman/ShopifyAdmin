//
//  AddCouponsViewController.swift
//  SwiftCart Admin
//
//  Created by Mac on 18/06/2024.
//

import UIKit
import RxSwift
import RxCocoa

class AddPriceRuleViewController: UIViewController {

    weak var coordinator: AppCoordinator?
    var viewModel: PriceRulesViewModel!
    private let disposeBag = DisposeBag()

    @IBOutlet weak var priceImageView: UIImageView!
    @IBOutlet weak var tfPriceTitle: UITextField!
    @IBOutlet weak var tfPriceValue: UITextField!
    @IBOutlet weak var btnValueType: UIButton!
    @IBOutlet weak var btnTargetType: UIButton!
    @IBOutlet weak var btnAllocationMethod: UIButton!
    @IBOutlet weak var tfUsageLimit: UITextField!
    @IBOutlet weak var schCodeUsage: UISwitch!
    @IBOutlet weak var dpStartsAt: UIDatePicker!
    @IBOutlet weak var dpEndsAt: UIDatePicker!
    
    
    var priceRule: PriceRule! = nil
    var isEdit = false
    
 private let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupPriceRule()
        setupDateFormatter()
        setupDatePicker()
        setupMenuButtons()
        setupViewModel()
    }
    
    func setupMenuButtons(){
        setupMenuButton(options: K.Enums.Coupons.valueType, for: btnValueType)
        setupMenuButton(options: K.Enums.Coupons.targetType, for: btnTargetType)
        setupMenuButton(options: K.Enums.Coupons.allocationMethod, for: btnAllocationMethod)
    }
    
    private func setupMenuButton(options: [String], for button: UIButton) {
        let menuItems = options.map { option in
            UIAction(title: option) { _ in
                if option == K.Enums.Coupons.targetType[1]{
                    self.priceImageView.image = K.Assets.Image.ShippingPlaceholder
                    self.tfPriceValue.text = "\(-100)"
                    self.tfPriceValue.isEnabled = false
                    self.btnValueType.setTitle(K.Enums.Coupons.valueType[1], for: .normal)
                    self.btnValueType.isEnabled = false
                    self.btnAllocationMethod.setTitle(K.Enums.Coupons.allocationMethod[1], for: .normal)
                    self.btnAllocationMethod.isEnabled = false
                } else if option == K.Enums.Coupons.targetType[0]{
                    self.tfPriceValue.isEnabled = true
                    self.btnValueType.isEnabled = true
                    self.btnAllocationMethod.isEnabled = true
                } else if option == K.Enums.Coupons.valueType[0]{
                    self.priceImageView.image = K.Assets.Image.PriceRulePlaceholder
                } else if option == K.Enums.Coupons.valueType[1]{
                    self.priceImageView.image = K.Assets.Image.PercentagePlaceholder
                }
                button.setTitle(option, for: .normal)
            }
        }
        
        let menu = UIMenu(title: button.titleLabel?.text ?? "Options", children: menuItems)
        
        button.menu = menu
        button.showsMenuAsPrimaryAction = true
    }
    
    func setupPriceRule(){
        if let priceRule{
            isEdit = true
            
            let valueType = priceRule.valueType == K.Enums.Coupons.valueType[1]
            let isShipping = priceRule.targetType == K.Enums.Coupons.targetType[1]
            
            priceImageView.image = isShipping ? K.Assets.Image.ShippingPlaceholder : valueType ? K.Assets.Image.PercentagePlaceholder : K.Assets.Image.PriceRulePlaceholder

            tfPriceTitle.text = priceRule.title
            tfPriceValue.text = priceRule.value
            btnValueType.setTitle(priceRule.valueType, for: .normal)
            btnTargetType.setTitle(priceRule.targetType, for: .normal)
            btnAllocationMethod.setTitle(priceRule.allocationMethod, for: .normal)
            tfUsageLimit.text = "\(priceRule.usageLimit ?? 0)"
            schCodeUsage.setOn(priceRule.oncePerCustomer ?? false, animated: true)
            
            dpStartsAt.date = dateFormatter.date(from: priceRule.startsAt ?? "") ?? Date()
            dpEndsAt.date = dateFormatter.date(from: priceRule.endsAt ?? "") ?? Date()
        }else {
            priceRule = PriceRule()
            
        }
    }

    func setupDateFormatter(){
        // Set the date format to match the input strings
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        // Set locale to en_US_POSIX to ensure consistent parsing
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    }   
    
    func setupDatePicker(){
        dpEndsAt.minimumDate = dpStartsAt.date
    }
    
    private func setupViewModel() {
        
        // Handle errors
        viewModel.errorDriver
            .drive(onNext: { error in
                // Handle error display or logging
                print("Error fetching Inventory: \(error)")
                Utils.showAlert(title: "Error", message: error.localizedDescription, preferredStyle: .alert, from: self)
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func switchCodeUsage(_ sender: UISwitch) {
        priceRule.oncePerCustomer = sender.isOn
    }
    
    @IBAction func changeStartsAt(_ sender: UIDatePicker) {
        priceRule.startsAt = dateFormatter.string(from: sender.date)
        dpEndsAt.minimumDate = sender.date
    }
    
    @IBAction func changeEndsAt(_ sender: UIDatePicker) {
        priceRule.endsAt = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func saveChanges(_ sender: UIButton) {
        guard let title = tfPriceTitle.text, !title.isEmpty else {
            Utils.showAlert(title: "Title", message: "Price Rule title is required.", preferredStyle: .alert, from: self)
            return
        }
        priceRule.title = title
        
        guard let priceText = tfPriceValue.text, !priceText.isEmpty, let price = Double(priceText), price < 0 else {
            Utils.showAlert(title: "Invalid Input", message: "Please provide valid negative price.", preferredStyle: .alert, from: self)
            return
        }
        priceRule.value = priceText
        
        guard let valueType = btnValueType.titleLabel?.text, !valueType.isEqual("Value Type") else {
            Utils.showAlert(title: "Value Type", message: "Value Type is required.", preferredStyle: .alert, from: self)
            return
        }
        priceRule.valueType = valueType
        
        guard let targetType = btnTargetType.titleLabel?.text, !targetType.isEqual("Target Type") else {
            Utils.showAlert(title: "Target Type", message: "Target Type is required.", preferredStyle: .alert, from: self)
            return
        }
        priceRule.targetType = targetType
        
        guard let allocationMethod = btnAllocationMethod.titleLabel?.text, !allocationMethod.isEqual("Allocation Method") else {
            Utils.showAlert(title: "Allocation Method", message: "Allocation Method is required.", preferredStyle: .alert, from: self)
            return
        }
        priceRule.allocationMethod = allocationMethod
        
        if isSameDay(firstDate: dpEndsAt.date, secondDate: Date()) || isSameDay(firstDate: dpEndsAt.date, secondDate: dpStartsAt.date){
            priceRule.endsAt = nil
        }
        
        if let usageLimitText = tfUsageLimit.text, !usageLimitText.isEmpty {
            if let usageLimit = Int(usageLimitText), usageLimit > 0{
                priceRule.usageLimit = usageLimit
            } else {
                Utils.showAlert(title: "Invalid Input", message: "Please provide valid usage Limit.", preferredStyle: .alert, from: self)
            }
        }
        
        if priceRule.startsAt == nil {
            priceRule.startsAt = dateFormatter.string(from: dpStartsAt.date)
        }
        
        print(priceRule!)
        sender.configuration?.showsActivityIndicator = true
        sender.isEnabled = false
        if isEdit{
            viewModel.updateItem(itemData: priceRule)
        } else {
            viewModel.addItem(itemData: priceRule)
        }
        viewModel.bindDataToVc = { [weak self] in
            self?.coordinator?.finish()
        }
    }

    @IBAction func goBack(_ sender: UIButton) {
        coordinator?.finish()
    }
    
    func isSameDay(firstDate: Date, secondDate: Date) -> Bool{
        
            let firstDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: firstDate)
            let secondDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: secondDate)
            
            return (firstDateComponents.year == secondDateComponents.year &&
                           firstDateComponents.month == secondDateComponents.month &&
                           firstDateComponents.day == secondDateComponents.day)
    }
}
