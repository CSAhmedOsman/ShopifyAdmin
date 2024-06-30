//
//  ProductImageCell.swift
//  SwiftCart Admin
//
//  Created by Mac on 12/06/2024.
//

import UIKit

class ProductImageCell: UICollectionViewCell {

    @IBOutlet weak var productImage: UIImageView!
    
    var indexPath = IndexPath(row: -1, section: -1)
    var deleteDelegate : (IndexPath)->Void = {_ in }
    
    @IBAction func deleteClick(_ sender: UIButton) {
        deleteDelegate(indexPath)
    }

}
