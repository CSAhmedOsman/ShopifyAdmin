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
    
    var deleteDelegate : (HomeCollectionViewCell, @escaping () -> ()) -> () = {_,_  in }
    var product: ProductDetail! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with product: ProductDetail?, deleteDelegate : @escaping (HomeCollectionViewCell, @escaping () -> ()) -> ()){
        
        self.deleteDelegate = deleteDelegate
        self.product = product
        self.layer.cornerRadius = 16
        deleteBtn.configuration?.showsActivityIndicator = false
        deleteBtn.setImage(K.SystemImage.trash, for: .normal)

        productImage.kf.setImage(with: URL(string: product?.image?.src ?? ""), placeholder: K.Assets.Image.productPlaceholder)
        
        productBrandName.text = product?.vendor
        productName.text = product?.title?.split(separator: "|").last?.trimmingCharacters(in: .whitespacesAndNewlines)
        productPrice.text = (product?.variants?.first??.price ?? "0") + " $"
    }
    
    @IBAction func deleteClick(_ sender: UIButton) {
        sender.configuration?.showsActivityIndicator = true
        sender.isEnabled = false
        deleteDelegate(self){
            sender.configuration?.showsActivityIndicator = false
            sender.isEnabled = true
        }
    }

}
