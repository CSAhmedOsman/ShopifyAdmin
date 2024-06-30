//
//  HomeTableViewController.swift
//  SwiftCart Admin
//
//  Created by Mac on 26/06/2024.
//

import UIKit
import RxSwift
import RxCocoa

class HomeTableViewController: UITableViewController {
    
    weak var coordinator: AppCoordinator?
    var viewModel: HomeTableViewModel!
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var discountCount: UILabel!
    @IBOutlet weak var priceRuleCount: UILabel!
    @IBOutlet weak var inventoriesCount: UILabel!
    @IBOutlet weak var productCount: UILabel!

    @IBOutlet weak var productIndicator: UIActivityIndicatorView!
    @IBOutlet weak var inventoryIndicator: UIActivityIndicatorView!
    @IBOutlet weak var priceIndicator: UIActivityIndicatorView!
    @IBOutlet weak var discountIndicator: UIActivityIndicatorView!
    
    let refreshControler = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControler.addTarget(self, action: #selector(loadCounts), for: .valueChanged)
        tableView.addSubview(refreshControler)
        
        productIndicator.hidesWhenStopped = true
        inventoryIndicator.hidesWhenStopped = true
        priceIndicator.hidesWhenStopped = true
        discountIndicator.hidesWhenStopped = true


        setupViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadCounts()
    }
    
    func updateLoadUI(){
        discountCount.text = ""
        priceRuleCount.text = ""
        inventoriesCount.text = ""
        productCount.text = ""
        
        productIndicator.startAnimating()
        inventoryIndicator.startAnimating()
        priceIndicator.startAnimating()
        discountIndicator.startAnimating()
    }
    
    private func setupViewModel() {
        // Handle errors
        viewModel.errorDriver
            .drive(onNext: {  [weak self] error in
                // Handle error display or logging
                print("Error fetching Data: \(error.localizedDescription)")
                if let self {
                    Utils.showAlert(title: "Error Fetching Data", message: error.localizedDescription, preferredStyle: .alert, from: self)
                }
            })
            .disposed(by: disposeBag)
        
        loadCounts()
    }

    @objc func loadCounts(){
        
        updateLoadUI()

        refreshControler.endRefreshing()
        viewModel.getCount(endpoint: K.Endpoint.Product.count) { [weak self] value in
            self?.productCount.text = "\(value)"
            self?.productIndicator.stopAnimating()
        }
        
        viewModel.getCount(endpoint: K.Endpoint.Inventory.locationCount) { [weak self] value in
            self?.inventoriesCount.text = "\(value)"
            self?.inventoryIndicator.stopAnimating()
        }
        
        viewModel.getCount(endpoint: K.Endpoint.Coupons.priceRuleCount) { [weak self] value in
            self?.priceRuleCount.text = "\(value)"
            self?.priceIndicator.stopAnimating()
        }
        
        viewModel.getCount(endpoint: K.Endpoint.Coupons.discountCount) { [weak self] value in
            self?.discountCount.text = "\(value)"
            self?.discountIndicator.stopAnimating()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tabBarController?.selectedIndex = indexPath.item <= 2 ? (indexPath.item + 1) : 3
    }
}
