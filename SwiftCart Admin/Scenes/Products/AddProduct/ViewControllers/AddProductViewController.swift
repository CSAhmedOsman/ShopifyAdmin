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
    
    var tags: [String] = []
    var options: [String] = []
    var optionValues: [[String]] = [[],[],[]]
    var product: ProductDetail! = nil
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        setupProductDetail()
        setupProductImagesCollection()
        setupTableViews()

        setupMenuButton(options: K.Enums.Product.vendors, for: vendorButton)
        setupMenuButton(options: K.Enums.Product.productTypes, for: productTypeButton)
        setupMenuButton(options: options, for: optionsButton)
        setupMenuButton(options: optionValues[0], for: option1Button)
        setupMenuButton(options: optionValues[1], for: option2Button)
        setupMenuButton(options: optionValues[2], for: option3Button)
    }
    
    private func setupProductDetail() {
        product = product ?? ProductDetail()
        
        tfProductName.text = product.title
        tvProductDescription.text = product.bodyHTML
        tfDefaultPrice.text = product.variants?.first??.price
        tags = product.tags?.components(separatedBy: ", ") ?? []
        
        vendorButton.setTitle(product.vendor, for: .normal)
        productTypeButton.setTitle(product.productType, for: .normal)
        
        var i = 0
        product.options?.forEach({ productOption in
            options.append(productOption?.name ?? "")
            optionValues[i] += productOption?.values ?? []
            i += 1
        })
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
                setupMenuButton(options: optionValues[1], for: option2Button)
            case 2:
                setupMenuButton(options: optionValues[2], for: option3Button)
            default:
                setupMenuButton(options: optionValues[0], for: option1Button)
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
        guard let option = tfOptionName.text, !option.isEmpty, options.count < 3,
              !options.contains(where: { $0.lowercased() == option.lowercased() }) else { return }
        
        options.append(option)
        setupMenuButton(options: options, for: optionsButton)
        
        optionValues.append([])
        productOptionsTable.reloadData()
        
        tfOptionName.text = ""
    }
    
    @IBAction func addOptionValue(_ sender: UIButton) {
        guard let option = optionsButton.titleLabel?.text, option != "Options",
              let value = tfOptionValue.text, !value.isEmpty else { return }
        
        let index = options.firstIndex { $0.lowercased() == option.lowercased() } ?? 0
        
        if !optionValues[index].contains(where: { $0.lowercased() == value.lowercased() }) {
            optionValues[index].append(value)
            
            setupProductVariantButtons()
            switch index {
            case 1:
                productOption2ValuesTable.reloadData()
            case 2:
                productOption3ValuesTable.reloadData()
            default:
                productOption1ValuesTable.reloadData()
            }
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
        
        let variant = ProductVariant(
            title: "\(option1 ?? "") / \(option2 ?? "") / \(option3 ?? "")",
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
        guard let title = tfProductName.text, !title.isEmpty else {
            Utils.showAlert(title: "Title", message: "Product title is required.", preferredStyle: .alert, from: self)
            return
        }
        
        product.title = title
        
        guard let images = product?.images, !images.isEmpty else {
            Utils.showAlert(title: "Image", message: "At least one image is required.", preferredStyle: .alert, from: self)
            return
        }
        
        product.image = images.first!
        
        guard let vendor = vendorButton.titleLabel?.text, vendor != "Vendor" else {
            Utils.showAlert(title: "Vendor", message: "Vendor is required.", preferredStyle: .alert, from: self)
            return
        }
        
        product.vendor = vendor
        
        guard let productType = productTypeButton.titleLabel?.text, productType != "Product Type" else {
            Utils.showAlert(title: "Product Type", message: "Product type is required.", preferredStyle: .alert, from: self)
            return
        }
        
        product.productType = productType
        
        guard let description = tvProductDescription.text, !description.isEmpty else {
            Utils.showAlert(title: "Description", message: "Product description is required.", preferredStyle: .alert, from: self)
            return
        }
        
        product.bodyHTML = description
        
        product.tags = tags.joined(separator: ", ")
        
        var i = -1
        product.options = options.map { option in
            i += 1
            return ProductOption(name: option, values: optionValues[i])
        }
        
        if (product.variants?.count ?? 0) <= 0{
            guard let price = tfDefaultPrice.text, !price.isEmpty,
                  price.allSatisfy({ $0.isNumber }) else {
                Utils.showAlert(title: "Invalid Input", message: "Please provide valid price or default price.", preferredStyle: .alert, from: self)
                return
                  }
            product.variants = (product.variants ?? []) + [ProductVariant(price: price)]
        }
        
        print("saveChanges: \(String(describing: product))")
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
            return optionValues[0].count
        case productOption2ValuesTable:
            return optionValues[1].count
        case productOption3ValuesTable:
            return optionValues[2].count
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
            cell.textLabel?.text = optionValues[0][indexPath.item]
        case productOption2ValuesTable:
            cell.textLabel?.text = optionValues[1][indexPath.item]
        case productOption3ValuesTable:
            cell.textLabel?.text = optionValues[2][indexPath.item]
        case productVariantsTable:
            cell.textLabel?.text = "Variant: \(product.variants?[indexPath.item]?.title ?? "")"
            cell.detailTextLabel?.text = "Price: \(product.variants?[indexPath.item]?.price ?? "0")"
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
                        self.optionValues.remove(at: indexPath.item)
                    case self.productOption1ValuesTable:
                        self.optionValues[0].remove(at: indexPath.item)
                    case self.productOption2ValuesTable:
                        self.optionValues[1].remove(at: indexPath.item)
                    case self.productOption3ValuesTable:
                        self.optionValues[2].remove(at: indexPath.item)
                    case self.productVariantsTable:
                        self.product.variants?.remove(at: indexPath.item)
                    default:
                        break
                    }
                    tableView.deleteRows(at: [indexPath], with: .fade)
                },
                UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ])
        }
    }
}
