//
//  CouponsViewController.swift
//  SwiftCart Admin
//
//  Created by Mac on 18/06/2024.
//

import UIKit
import RxSwift
import RxCocoa

class PriceRulesViewController: UIViewController {

    weak var coordinator: AppCoordinator?
    var viewModel: PriceRulesViewModel!
    private let disposeBag = DisposeBag()

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var spaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var dataTable: UITableView!
    @IBOutlet weak var imageNoData: UIImageView!

    private let refreshControl = UIRefreshControl()

    private var allPriceRules: [PriceRule] = []

    var searchBarHeight: CGFloat = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupSearchView()
        setupViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBarHeight = searchBar.frame.height + 8
        viewModel.getAllItems()
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
            self?.allPriceRules = self?.viewModel.priceRuleResponse?.priceRules ?? []
            self?.dataTable.reloadData()
        }
        
        // Handle errors
        viewModel.errorDriver
            .drive(onNext: { [weak self] error in
                // Handle error display or logging
                print("Error fetching Inventory: \(error.localizedDescription)")
                if let self {
                    Utils.showAlert(title: "Error fetching Price Rules", message: error.localizedDescription, preferredStyle: .alert, from: self)
                }
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func addPriceRule(_ sender: Any) {
        coordinator?.gotoAddPriceRule()
    }
    
    @IBAction func toggleShowSearchBar(_ sender: Any) {
        // Toggle the visibility of the hidden view with animation
        self.searchBar.isHidden = !self.searchBar.isHidden
        UIView.animate(withDuration: 0.5) {
            self.toggleShow(theVeiw: self.searchBar, isViewVisible: self.searchBar.isHidden, spaceConstraint: self.spaceConstraint, forHeight: self.searchBarHeight)
        }
    }
    
    @IBAction func editPriceRule(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? UITableViewCell, let indexPath = dataTable.indexPath(for: cell) else{ return }
        coordinator?.gotoAddPriceRule(priceRule: allPriceRules[indexPath.item])
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

extension PriceRulesViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            allPriceRules = viewModel.priceRuleResponse?.priceRules ?? []
        } else {
            allPriceRules = (viewModel.priceRuleResponse?.priceRules ?? []).filter { $0.title?.lowercased().contains(searchText.lowercased()) ?? false }
        }
        dataTable.reloadData()
    }
}

// MARK: - UISearchBarDelegate

extension PriceRulesViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = allPriceRules.count
        imageNoData.isHidden = count > 0
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CustomView.defaultCellIdentifier, for: indexPath) as! PriceRuleTableViewCell
        
        cell.configuration(for: allPriceRules[indexPath.item])
        
        cell.layer.cornerRadius = 12
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.gotoDiscounts(with: allPriceRules[indexPath.item].id ?? 0)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Utils.showAlert(title: "Delete Rule", message: "Are you sure you want to remove this Rule?", preferredStyle: .alert, from: self, actions: [
                UIAlertAction(title: "Delete", style: .destructive) { _ in
                    self.viewModel.deleteItem(at: self.allPriceRules[indexPath.item].id ?? 0)
                    self.viewModel.bindDeleteDataFromVc = { [weak self] in
                        self?.allPriceRules.remove(at: indexPath.item)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                },
                UIAlertAction(title: "Cancel", style: .cancel)
            ])
        }
    }
}
