//
//  HomeCollectionViewCell.swift
//  SwiftCart Admin
//
//  Created by Mac on 07/06/2024.
//

import UIKit
import Cosmos
import Kingfisher

class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productBrandName: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var deleteDelegate : (HomeCollectionViewCell)->() = {_ in }
    var product: ProductDetail! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with product: ProductDetail?, deleteDelegate : @escaping (HomeCollectionViewCell)->Void){
        
        self.deleteDelegate = deleteDelegate
        self.product = product
        self.layer.cornerRadius = 16
        deleteBtn.configuration?.showsActivityIndicator = false
        deleteBtn.imageView?.image = K.SystemImage.trash

        productImage.kf.setImage(with: URL(string: product?.image?.src ?? ""), placeholder: K.Assets.Image.productPlaceholder)
        
        productBrandName.text = product?.vendor
        productName.text = product?.title?.split(separator: "|").last?.trimmingCharacters(in: .whitespacesAndNewlines)
        productPrice.text = (product?.variants?.first??.price ?? "0") + " $"
    }
    
    @IBAction func deleteClick(_ sender: UIButton) {
        print("click btn in index)")
        sender.configuration?.showsActivityIndicator = true
        deleteDelegate(self)
    }

}
