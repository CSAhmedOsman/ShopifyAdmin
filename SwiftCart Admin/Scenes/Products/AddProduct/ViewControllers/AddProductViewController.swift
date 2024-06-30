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
    
    // MARK: - Properties
    weak var coordinator: AppCoordinator?
    var viewModel: ProductViewModel!
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var tfProductName: UITextField!
    @IBOutlet weak var tfImageURL: UITextField!
    @IBOutlet weak var tfDefaultPrice: UITextField!
    @IBOutlet weak var imageNoData: UIImageView!
    @IBOutlet weak var tvProductDescription: UITextView!
    @IBOutlet weak var productImagesCollection: UICollectionView!
    @IBOutlet weak var vendorButton: UIButton!
    @IBOutlet weak var productTypeButton: UIButton!
    @IBOutlet weak var tfProductTag: UITextField!
    @IBOutlet weak var productTagsTable: UITableView!
    @IBOutlet weak var tfOptionName: UITextField!
    @IBOutlet weak var productOptionsTable: UITableView!
    @IBOutlet weak var tfOptionValue: UITextField!
    @IBOutlet weak var productOption1ValuesTable: UITableView!
    @IBOutlet weak var productOption2ValuesTable: UITableView!
    @IBOutlet weak var productOption3ValuesTable: UITableView!
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var option1Button: UIButton!
    @IBOutlet weak var option2Button: UIButton!
    @IBOutlet weak var option3Button: UIButton!
    @IBOutlet weak var tfProductPrice: UITextField!
    @IBOutlet weak var tfProductQuantity: UITextField!
    @IBOutlet weak var productVariantsTable: UITableView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var tags: [String] = []
    var options: [String] = []{
        didSet{
            setupMenuButton(options: options, for: optionsButton)
        }
    }
    var option1Values: [String] = []{
        didSet{
            setupMenuButton(options: option1Values, for: option1Button)
            productOption1ValuesTable.reloadData()
        }
    }
    var option2Values: [String] = []{
        didSet{
            setupMenuButton(options: option2Values, for: option2Button)
            productOption2ValuesTable.reloadData()
        }
    }
    var option3Values: [String] = []{
        didSet{
            setupMenuButton(options: option3Values, for: option3Button)
            productOption3ValuesTable.reloadData()
        }
    }
    
    var product: ProductDetail! = nil
    var isEdit = false
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
    }
    
    // MARK: - Setup Methods
    
    private func setupViewModel(){
        // Bind product data to collection view using RxSwift
        viewModel.bindDataToVc = { [weak self] in
            self?.coordinator?.finish()
        }
        
        // Handle errors
        viewModel.errorDriver
            .drive(onNext: { [weak self] error in
                // Handle error display or logging
                print("Error Save Product: \(error.localizedDescription)")
                self?.saveButton.configuration?.showsActivityIndicator = false
                if let self {
                    Utils.showAlert(title: "Error Save Product", message: error.localizedDescription, preferredStyle: .alert, from: self)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupUI() {
        setupProductDetail()
        setupProductImagesCollection()
        setupTableViews()
        
        setupMenuButton(options: K.Value.Product.vendors, for: vendorButton)
        setupMenuButton(options: K.Value.Product.productTypes, for: productTypeButton)
//        setupMenuButton(options: options, for: optionsButton)
//        setupMenuButton(options: option1Values, for: option1Button)
//        setupMenuButton(options: option2Values, for: option2Button)
//        setupMenuButton(options: option3Values, for: option3Button)
    }
    
    private func setupProductDetail() {
        
        if let product{
            isEdit = true
            
            tfProductName.text = product.title
            tvProductDescription.text = product.bodyHTML
            tfDefaultPrice.text = product.variants?.first??.price
            tags = product.tags?.components(separatedBy: ", ") ?? []
            
            vendorButton.setTitle(product.vendor, for: .normal)
            productTypeButton.setTitle(product.productType, for: .normal)
            
            var i = 0
            product.options?.forEach({ productOption in
                options.append(productOption?.name ?? "")
                switch i{
                case 1:
                    option2Values += productOption?.values ?? []
                case 2:
                    option3Values += productOption?.values ?? []
                default:
                    option1Values += productOption?.values ?? []
                }
                i += 1
            })
        }else {
            product = ProductDetail()
        }
    }
    
    private func setupTableViews() {
        let tables = [productTagsTable, productOptionsTable, productOption1ValuesTable, productOption2ValuesTable, productOption3ValuesTable, productVariantsTable]
        
        tables.forEach { table in
            table?.delegate = self
            table?.dataSource = self
            table?.layer.cornerRadius = 12
        }
    }
    
    private func setupProductImagesCollection() {
        productImagesCollection.delegate = self
        productImagesCollection.dataSource = self
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
    
    private func setupProductVariantButtons() {
        options.enumerated().forEach { index, _ in
            switch index {
            case 1:
                setupMenuButton(options: option2Values, for: option2Button)
            case 2:
                setupMenuButton(options: option3Values, for: option3Button)
            default:
                setupMenuButton(options: option1Values, for: option1Button)
            }
        }
    }
    
    // MARK: - Action Methods
    @IBAction func addImage(_ sender: UIButton) {
        guard let src = tfImageURL.text, !src.isEmpty else { return }
        
        let productImage = ProductImage(src: src)
        product.images = (product.images ?? []) + [productImage]
        productImagesCollection.reloadData()
        
        tfImageURL.text = ""
    }
    
    @IBAction func removeProductImage(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? UICollectionViewCell,
              let indexPath = productImagesCollection.indexPath(for: cell) else { return }
        
        Utils.showAlert(title: "Delete Image", message: "Are you sure to delete this image", preferredStyle: .alert, from: self, actions: [
            UIAlertAction(title: "Delete", style: .destructive) { _ in
                self.product.images?.remove(at: indexPath.item)
                self.productImagesCollection.deleteItems(at: [indexPath])
            },
            UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ])
    }
    
    @IBAction func addTag(_ sender: UIButton) {
        guard let tag = tfProductTag.text, !tag.isEmpty,
              !tags.contains(where: { $0.lowercased() == tag.lowercased() }) else { return }
        
        tags.append(tag)
        productTagsTable.reloadData()
        
        tfProductTag.text = ""
    }
    
    @IBAction func addOption(_ sender: UIButton) {
        guard let option = tfOptionName.text?.capitalized, !option.isEmpty, options.count < 3,
              !options.contains(where: { $0.lowercased() == option.lowercased() }) else { return }
        
        options.append(option)
        
        productOptionsTable.reloadData()
        
        tfOptionName.text = ""
    }
    
    @IBAction func addOptionValue(_ sender: UIButton) {
        guard let option = optionsButton.titleLabel?.text, option != "Options",
              let value = tfOptionValue.text, !value.isEmpty else { return }
        
        let index = options.firstIndex { $0.lowercased() == option.lowercased() } ?? 0
        
        switch index{
        case 1:
            if !option2Values.contains(where: { $0.lowercased() == value.lowercased() }) {
                option2Values.append(value)
            }
        case 2:
            if !option3Values.contains(where: { $0.lowercased() == value.lowercased() }) {
                option3Values.append(value)
            }
        default:
            if !option1Values.contains(where: { $0.lowercased() == value.lowercased() }) {
                option1Values.append(value)
            }
        }
        setupProductVariantButtons()
        switch index {
        case 1:
            productOption2ValuesTable.reloadData()
        case 2:
            productOption3ValuesTable.reloadData()
        default:
            productOption1ValuesTable.reloadData()
        }
        
        tfOptionValue.text = ""
    }
    
    @IBAction func addVariant(_ sender: Any) {
        
        var priceText = "price"
        if let price = tfProductPrice.text, !price.isEmpty, price.allSatisfy({ $0.isNumber }){
            priceText = price
        } else if let price = tfDefaultPrice.text, !price.isEmpty,
                  price.allSatisfy({ $0.isNumber }){
            priceText = price
        } else {
            Utils.showAlert(title: "Invalid Input", message: "Please provide valid price or default price.", preferredStyle: .alert, from: self)
            return
        }
        
        guard let quantityText = tfProductQuantity.text, !quantityText.isEmpty, let quantity = Int(quantityText) else {
            Utils.showAlert(title: "Invalid Input", message: "Please provide valid quantity.", preferredStyle: .alert, from: self)
            return
        }
        
        let option1 = option1Button.titleLabel?.text == "Option1" ? nil : option1Button.titleLabel?.text
        let option2 = option2Button.titleLabel?.text == "Option2" ? nil : option2Button.titleLabel?.text
        let option3 = option3Button.titleLabel?.text == "Option3" ? nil : option3Button.titleLabel?.text
        
        let options = [option1, option2, option3].compactMap { $0 }
        
        let title = options.isEmpty ? tfProductName.text : options.joined(separator: " / ")
        
        let variant = ProductVariant(
            title: title,
            price: priceText,
            option1: option1,
            option2: option2,
            option3: option3,
            inventoryQuantity: quantity
        )
        
        product.variants = (product.variants ?? []) + [variant]
        
        tfProductPrice.text = ""
        tfProductQuantity.text = ""
        productVariantsTable.reloadData()
    }
    
    @IBAction func saveChanges(_ sender: UIButton) {
        guard let title = tfProductName.text?.capitalized, !title.isEmpty else {
            Utils.showAlert(title: "Title", message: "Product title is required.", preferredStyle: .alert, from: self)
            return
        }
                
        guard let images = product?.images, !images.isEmpty else {
            Utils.showAlert(title: "Image", message: "At least one image is required.", preferredStyle: .alert, from: self)
            return
        }
        
        guard let vendor = vendorButton.titleLabel?.text, vendor != "Vendor" else {
            Utils.showAlert(title: "Vendor", message: "Vendor is required.", preferredStyle: .alert, from: self)
            return
        }
        
        guard let productType = productTypeButton.titleLabel?.text, productType != "Product Type" else {
            Utils.showAlert(title: "Product Type", message: "Product type is required.", preferredStyle: .alert, from: self)
            return
        }
        
        guard let description = tvProductDescription.text, !description.isEmpty else {
            Utils.showAlert(title: "Description", message: "Product description is required.", preferredStyle: .alert, from: self)
            return
        }
        
        guard options.count > 0 && option1Values.count > 0 else {
            Utils.showAlert(title: "Options", message: "At least one option with one value is required.", preferredStyle: .alert, from: self)
            return
        }
        
        let name = title.split(separator: "|").last?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        product.title = "\(vendor) | \(name ?? "")"
        product.vendor = vendor
        product.image = images.first!
        product.productType = productType
        product.bodyHTML = description
        
        product.tags = tags.joined(separator: ", ")
        
        var i = -1
        product.options = options.map { option in
            i += 1
            switch i{
            case 1:
                return ProductOption(name: option, values: option2Values)
            case 2:
                return ProductOption(name: option, values: option3Values)
            default:
                return ProductOption(name: option, values: option1Values)
            }
        }
        
        if (product.variants?.count ?? 0) <= 0{
            guard let price = tfDefaultPrice.text, !price.isEmpty,
                  price.allSatisfy({ $0.isNumber }) else {
                Utils.showAlert(title: "Invalid Input", message: "Please provide valid price or default price.", preferredStyle: .alert, from: self)
                return
            }
            product.variants = (product.variants ?? []) + [ProductVariant(title: option1Values.first ?? "OS", price: price, option1: option1Values.first ?? "OS")]
        }
        
        sender.configuration?.showsActivityIndicator = true
        sender.isEnabled = false
        
        print("saveChanges: \(String(describing: product))")
        if isEdit{
            viewModel.updateItem(itemData: ProductResponse(product: product))
        }else {
            viewModel.addItem(itemData: ProductResponse(product: product))
        }

    }
    
    
    @IBAction func goBack(_ sender: UIButton) {
        coordinator?.finish()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
extension AddProductViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = product?.images?.count ?? 0
        imageNoData.isHidden = count > 0
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CustomView.addProductImageCellIdentifier, for: indexPath)
        (cell.viewWithTag(2) as! UIImageView).kf.setImage(with: URL(string: product?.images?[indexPath.item]?.src ?? ""), placeholder: K.Assets.Image.productPlaceholder)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height - 8
        return CGSize(width: height, height: height)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension AddProductViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case productTagsTable:
            return tags.count
        case productOptionsTable:
            return options.count
        case productOption1ValuesTable:
            return option1Values.count
        case productOption2ValuesTable:
            return option2Values.count
        case productOption3ValuesTable:
            return option3Values.count
        case productVariantsTable:
            return product.variants?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CustomView.defaultCellIdentifier, for: indexPath)
        cell.layer.cornerRadius = 16
        
        switch tableView {
        case productTagsTable:
            cell.textLabel?.text = tags[indexPath.item]
        case productOptionsTable:
            cell.textLabel?.text = options[indexPath.item]
        case productOption1ValuesTable:
            cell.textLabel?.text = option1Values[indexPath.item]
        case productOption2ValuesTable:
            cell.textLabel?.text = option2Values[indexPath.item]
        case productOption3ValuesTable:
            cell.textLabel?.text = option3Values[indexPath.item]
        case productVariantsTable:
            let variant = product.variants?[indexPath.item]
            cell.textLabel?.text = "Variant: \(variant?.title ?? "")"
            cell.detailTextLabel?.text = "Quantity: \(variant?.inventoryQuantity ?? 0), Price: \(variant?.price ?? "0")"
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Utils.showAlert(title: "Remove Cell", message: "Are you sure you want to remove this cell?", preferredStyle: .alert, from: self, actions: [
                UIAlertAction(title: "Delete", style: .destructive) { _ in
                    switch tableView {
                    case self.productTagsTable:
                        self.tags.remove(at: indexPath.item)
                    case self.productOptionsTable:
                        self.options.remove(at: indexPath.item)
                        switch indexPath.item {
                        case 0:
                            self.option1Values = []
                        case 1:
                            self.option2Values = []
                        case 2:
                            self.option3Values = []
                        default:
                            break
                        }
                    case self.productOption1ValuesTable:
                        self.option1Values.remove(at: indexPath.item)
                    case self.productOption2ValuesTable:
                        self.option2Values.remove(at: indexPath.item)
                    case self.productOption3ValuesTable:
                        self.option3Values.remove(at: indexPath.item)
                    case self.productVariantsTable:
                        self.product.variants?.remove(at: indexPath.item)
                    default:
                        break
                    }
                    tableView.deleteRows(at: [indexPath], with: .fade)
                },
                UIAlertAction(title: "Cancel", style: .cancel)
            ])
        }
    }
}
