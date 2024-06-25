//
//  DiscountViewController.swift
//  SwiftCart Admin
//
//  Created by Mac on 25/06/2024.
//

import UIKit
import RxSwift
import RxCocoa

class DiscountViewController: UIViewController {

    weak var coordinator: AppCoordinator?
    var viewModel: DiscountViewModel!
    private let disposeBag = DisposeBag()

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var spaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var dataTable: UITableView!
    @IBOutlet weak var imageNoData: UIImageView!

    private let refreshControl = UIRefreshControl()

    private var allDiscounts: [DiscountCode] = []

    var searchBarHeight: CGFloat = 4
    
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
    
    func setupTableView(){
        dataTable.delegate = self
        dataTable.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        dataTable.addSubview(refreshControl)
    }
    
    func setupSearchView(){
        searchBar.delegate = self
        searchBar.isHidden = true
    }
    
    private func setupViewModel() {
        // Bind product data to collection view using RxSwift
        viewModel.bindDataToVc = { [weak self] in
            self?.allDiscounts = self?.viewModel.discountCodeResponse?.discountCodes ?? []
            self?.dataTable.reloadData()
        }
        
        // Handle errors
        viewModel.errorDriver
            .drive(onNext: { error in
                // Handle error display or logging
                print("Error fetching Inventory: \(error)")
                Utils.showAlert(title: "Error", message: error.localizedDescription, preferredStyle: .alert, from: self)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func addDiscount(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: K.Main.addDiscountVCName) as! AddDiscountViewController
        vc.bindDataToBackScreen = { newCode in
            let discount = DiscountCode(code: newCode)
            self.viewModel.addItem(itemData: discount)
        }
        
        self.present(vc, animated: true)
    }
    
    @IBAction func toggleShowSearchBar(_ sender: Any) {
        // Toggle the visibility of the hidden view with animation
        self.searchBar.isHidden = !self.searchBar.isHidden
        UIView.animate(withDuration: 0.5) {
            self.toggleShow(theVeiw: self.searchBar, isViewVisible: self.searchBar.isHidden, spaceConstraint: self.spaceConstraint, forHeight: self.searchBarHeight)
        }
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        coordinator?.finish()
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

extension DiscountViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            allDiscounts = viewModel.discountCodeResponse?.discountCodes ?? []
        } else {
            allDiscounts = (viewModel.discountCodeResponse?.discountCodes ?? []).filter { $0.code?.lowercased().contains(searchText.lowercased()) ?? false }
        }
        dataTable.reloadData()
    }
}

// MARK: - UISearchBarDelegate

extension DiscountViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = allDiscounts.count
        imageNoData.isHidden = count > 0
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CustomView.defaultCellIdentifier, for: indexPath)
        
        cell.textLabel?.text = allDiscounts[indexPath.item].code
        cell.detailTextLabel?.text = "Usage: \(allDiscounts[indexPath.item].usageCount ?? 0)"
        
        cell.layer.cornerRadius = 12
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: K.Main.addDiscountVCName) as! AddDiscountViewController
        
        vc.value = allDiscounts[indexPath.item].code ?? ""
        vc.bindDataToBackScreen = { newCode in
            var discount = self.allDiscounts[indexPath.item]
            discount.code = newCode
            self.viewModel.updateItem(itemData: discount)
        }
        
        self.present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Utils.showAlert(title: "Delete Discount", message: "Are you sure you want to remove this Code?", preferredStyle: .alert, from: self, actions: [
                UIAlertAction(title: "Delete", style: .destructive) { _ in
                    self.viewModel.deleteItem(at: self.allDiscounts[indexPath.item].id ?? 0)
                    self.viewModel.bindDeleteDataFromVc = { [weak self] in
                        self?.allDiscounts.remove(at: indexPath.item)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                },
                UIAlertAction(title: "Cancel", style: .cancel)
            ])
        }
    }
}
