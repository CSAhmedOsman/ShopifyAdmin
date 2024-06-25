//
//  ViewController.swift
//  SwiftCart Admin
//
//  Created by Mac on 31/05/2024.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    // MARK: - Properties
    
    weak var coordinator: AppCoordinator?
    var viewModel: ProductViewModel!
    private let disposeBag = DisposeBag()
        
    @IBOutlet weak var spaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var productCollection: UICollectionView!
    @IBOutlet weak var imageNoData: UIImageView!
    
    private let refreshControl = UIRefreshControl()

    private var allProducts: [ProductDetail] = []
    
    var searchBarHeight: CGFloat = 4
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationController?.navigationBar.isHidden = true
        
        setupCollectionView()
        setupViewModel()
        setupSearchView()
    }
    
    func setupSearchView(){
        searchBar.delegate = self
        searchBar.isHidden = true
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
    
    private func setupCollectionView() {
        let nib = UINib(nibName: K.CustomView.homeProductCellName, bundle: Bundle.main)
        productCollection.register(nib, forCellWithReuseIdentifier: K.CustomView.homeProductCellIdentifier)
        
        productCollection.delegate = self
        productCollection.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        productCollection.addSubview(refreshControl)
    }
    
    private func setupViewModel() {
        // Bind product data to collection view using RxSwift
        viewModel.bindDataToVc = { [weak self] in
            self?.allProducts = self?.viewModel.productResponse?.products ?? []
            self?.productCollection.reloadData()
        }
        
        // Handle errors
        viewModel.errorDriver
            .drive(onNext: { error in
                // Handle error display or logging
                print("Error fetching products: \(error.localizedDescription)")
                Utils.showAlert(title: "Error", message: error.localizedDescription, preferredStyle: .alert, from: self)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - IBActions

    @IBAction func addProduct(_ sender: Any) {
        coordinator?.gotoAddProduct()
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

extension HomeViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            allProducts = viewModel.productResponse?.products ?? []
        } else {
            allProducts = (viewModel.productResponse?.products ?? []).filter { $0.title?.lowercased().contains(searchText.lowercased()) ?? false }
        }
        productCollection.reloadData()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout, UICollectionViewDataSource

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = allProducts.count
        imageNoData.isHidden = count > 0
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CustomView.homeProductCellIdentifier, for: indexPath)
        
        if let cell = cell as? HomeCollectionViewCell{
            cell.configure(with: allProducts[indexPath.item]){ [weak self] cell, completion  in
                let indexPath = (self?.productCollection.indexPath(for: cell))!
                print("before call delete method with index \(indexPath)")
                self?.deleteCell(indexPath: indexPath, product: cell.product, complation: completion)
            }
        }else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CustomView.defaultCellIdentifier, for: indexPath)
        }
        
        return cell
    }

    func deleteCell(indexPath:IndexPath, product: ProductDetail, complation: @escaping () -> ()){
        print("After call delete method with index \(indexPath.item)")
        Utils.showAlert(title: "Remove Product", message: "Are you sure remove this Product?", preferredStyle: .alert, from: self,actions: [UIAlertAction(title: "Delete", style: .destructive){ _ in
            self.viewModel.bindDeleteDataFromVc = { [weak self] in
                DispatchQueue.main.async {
                    self?.allProducts.remove(at: indexPath.item)
                    self?.productCollection.deleteItems(at: [indexPath])
                    complation()
                }
            }
            self.viewModel.deleteItem(at: product.id ?? 0)
        },UIAlertAction(title: "Cancel", style: .cancel,handler: { _ in
            complation()
        })])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 18) / 2
        return CGSize(width: width, height: (width * 3 / 2))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.gotoAddProduct(product: allProducts[indexPath.item])
    }
}
