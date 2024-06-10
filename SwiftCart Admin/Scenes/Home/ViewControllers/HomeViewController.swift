//
//  ViewController.swift
//  SwiftCart Admin
//
//  Created by Mac on 31/05/2024.
//

import UIKit

class HomeViewController: UIViewController {
    weak var coordinator: AppCoordinator?

    @IBOutlet weak var spaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var isSearchBarVisible = false
    var searchBarHeight: CGFloat = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        searchBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBarHeight = searchBar.frame.height + 8
        
  }
    
    @IBAction func toggleShowSearchBar(_ sender: Any) {

        // Toggle the visibility of the hidden view with animation
        UIView.animate(withDuration: 0.5) {
            self.toggleShow(theVeiw: self.searchBar, isViewVisible: self.isSearchBarVisible, spaceConstraint: self.spaceConstraint, forHeight: self.searchBarHeight)
        }
        self.isSearchBarVisible = !self.isSearchBarVisible
    }
    
    func toggleShow(theVeiw: UIView, isViewVisible: Bool, spaceConstraint: NSLayoutConstraint, forHeight: CGFloat){
        
        spaceConstraint.constant = isViewVisible ? 4 : forHeight
        theVeiw.isHidden = isViewVisible
        
        self.view.layoutIfNeeded()
    }
}
