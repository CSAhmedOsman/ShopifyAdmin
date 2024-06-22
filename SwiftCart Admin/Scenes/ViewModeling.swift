//
//  ViewModeling.swift
//  SwiftCart Admin
//
//  Created by Mac on 22/06/2024.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModeling {
    associatedtype T

    // Driver variables
    var errorDriver: Driver<Error> { get }

    // Bind data to view
    var bindDataToVc: () -> () {get set}
    var bindDeleteDataFromVc: () -> () {get set}
    
    // CRUD operations
    func getAllItems()
    func addItem(itemData: T)
    func getItem(byId: Int64)
    func updateItem(itemData: T)
    func deleteItem(at: Int64)
}
