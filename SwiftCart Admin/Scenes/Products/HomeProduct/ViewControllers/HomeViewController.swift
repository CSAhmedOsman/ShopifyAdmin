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
    
    var searchBarHeight: CGFloat = 4
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        searchBar.isHidden = true

        setupCollectionView()
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
    
    private func setupCollectionView() {
        let nib = UINib(nibName: K.CustomView.homeProductCellName, bundle: Bundle.main)
        productCollection.register(nib, forCellWithReuseIdentifier: K.CustomView.homeProductCell)
        
        productCollection.delegate = self
        productCollection.dataSource = self
    }
    
    private func setupViewModel() {
        // Bind product data to collection view using RxSwift
        viewModel.bindDataToVc = { [weak self] in
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
}


// MARK: - UICollectionViewDelegateFlowLayout, UICollectionViewDataSource

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = viewModel.productResponse?.products?.count ?? 0
        imageNoData.isHidden = count > 0
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CustomView.homeProductCell, for: indexPath)
        
        if let cell = cell as? HomeCollectionViewCell{
            cell.configure(with: viewModel.productResponse?.products?[indexPath.row]){ [weak self] cell in
                let indexPath = (self?.productCollection.indexPath(for: cell))!
                print("before call delete method with index \(indexPath)")
                self?.deleteCell(indexPath: indexPath, product: cell.product)
            }
        }else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CustomView.emptyCell, for: indexPath)
        }
        
        return cell
    }

    func deleteCell(indexPath:IndexPath, product: ProductDetail){
        print("After call delete method with index \(indexPath.item)")
        viewModel.bindDeleteDataFromVc = { [weak self] in
            self?.productCollection.deleteItems(at: [indexPath])
        }
        viewModel.deleteItem(at: Int64(indexPath.item))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 18) / 2
        return CGSize(width: width, height: (width * 3 / 2))
    }
}
