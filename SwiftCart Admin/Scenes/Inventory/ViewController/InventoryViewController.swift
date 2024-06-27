//
//  InventoryViewController.swift
//  SwiftCart Admin
//
//  Created by Mac on 24/06/2024.
//

import UIKit
import RxSwift
import RxCocoa

class InventoryViewController: UIViewController {

    weak var coordinator: AppCoordinator?
    var viewModel: InventoryViewModel!
    private let disposeBag = DisposeBag()

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var spaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var inventoryLevelsTable: UITableView!
    @IBOutlet weak var imageNoData: UIImageView!

    private var allInventoryLevels: [InventoryLevel] = []

    var searchBarHeight: CGFloat = 4
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSearchView()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getAllItems()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBarHeight = searchBar.frame.height + 8
    }
    
    // MARK: - Setup Methods
    
    func setupSearchView(){
        searchBar.delegate = self
        searchBar.isHidden = true
    }
    
    private func setupTableView() {
        inventoryLevelsTable.delegate = self
        inventoryLevelsTable.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        inventoryLevelsTable.addSubview(refreshControl)
    }
    
    private func setupViewModel() {
        // Bind product data to collection view using RxSwift
        viewModel.bindDataToVc = { [weak self] in
            self?.allInventoryLevels = self?.viewModel.inventoryLevelResponse?.inventoryLevels ?? []
            self?.inventoryLevelsTable.reloadData()
        }
        
        // Handle errors
        viewModel.errorDriver
            .drive(onNext: { [weak self] error in
                // Handle error display or logging
                print("Error fetching Inventory: \(error.localizedDescription)")
                if let self {
                    Utils.showAlert(title: "Error fetching Inventory", message: error.localizedDescription, preferredStyle: .alert, from: self)
                }
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func toggleShowSearchBar(_ sender: Any) {
        // Toggle the visibility of the hidden view with animation
        self.searchBar.isHidden = !self.searchBar.isHidden
        UIView.animate(withDuration: 0.5) {
            self.toggleShow(theVeiw: self.searchBar, isViewVisible: self.searchBar.isHidden, spaceConstraint: self.spaceConstraint, forHeight: self.searchBarHeight)
        }
    }
    
    // MARK: - Helper Methods
    
    func toggleShow(theVeiw: UIView, isViewVisible: Bool, spaceConstraint: NSLayoutConstraint, forHeight: CGFloat){
        
        spaceConstraint.constant = isViewVisible ? 4 : forHeight
        theVeiw.isHidden = isViewVisible
        
        self.view.layoutIfNeeded()
    }
    
    @objc func refreshData(){
        refreshControl.endRefreshing()
        viewModel.getAllItems()
    }
}

// MARK: - UISearchBarDelegate

extension InventoryViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            allInventoryLevels = viewModel.inventoryLevelResponse?.inventoryLevels ?? []
        } else {
            allInventoryLevels = (viewModel.inventoryLevelResponse?.inventoryLevels ?? []).filter { "\($0.inventoryItemId)".contains(searchText) }
        }
        inventoryLevelsTable.reloadData()
    }
}

// MARK: - UISearchBarDelegate

extension InventoryViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = allInventoryLevels.count
        imageNoData.isHidden = count > 0
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CustomView.defaultCellIdentifier, for: indexPath) as! InventoryTableViewCell
        
        cell.config(item: allInventoryLevels[indexPath.item])
        
        cell.layer.cornerRadius = 12
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var inventoryItem = allInventoryLevels[indexPath.item]
        
        if inventoryItem.inventoryManagement == K.Value.Product.inventoryManager {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: K.Main.editQuntatyVCName) as? EditQuntatyViewController else { return }
            
            let value = inventoryItem.available ?? 0
            vc.value = value
            vc.bindDataToInventoryScreen = { newValue in
                if newValue != value{
                    inventoryItem.available = newValue
                    self.viewModel.updateItem(itemData: inventoryItem)
                    self.refreshData()
                }
            }
            self.present(vc, animated: true)
        }else {
            Utils.showAlert(title: "Edit Item", message: "Inventory item does not have inventory tracking enabled", preferredStyle: .alert, from: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
    }
}
