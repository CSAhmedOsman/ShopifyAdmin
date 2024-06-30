//
//  InventoryViewModel.swift
//  SwiftCart Admin
//
//  Created by Mac on 24/06/2024.
//

import Foundation
import RxSwift
import RxCocoa

class InventoryViewModel{
        
    var inventoryLevelResponse: InventoryLevelResponse? = nil
    
    private var service: Servicing
    private let disposeBag = DisposeBag()
    
    // Expose a driver for product details
    var bindDataToVc: () -> () = {}
    var bindDeleteDataFromVc: () -> () = {}
    // Expose a driver for errors
    private let errorSubject = PublishSubject<Error>()
    var errorDriver: Driver<Error> {
        return errorSubject.asDriver(onErrorDriveWith: .empty())
    }
    
    init(service: Servicing) {
        self.service = service
    }
    
    func getAllItems() {
//        service.makeAPICall(method: .get, endpoint: K.Endpoint.Inventory.inventoryLevels, byId: nil, itemData: nil)
//            .flatMap { data -> Observable<InventoryLevelResponse> in
//                if let inventoryResponse: InventoryLevelResponse = Utils.decode(from: data) {
//                    return Observable.just(inventoryResponse)
//                } else {
//                    return Observable.error(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode product response"]))
//                }
//            }
//            .subscribe(onNext: { [weak self] response in
//                print(response)
//                self?.inventoryLevelResponse = response
//                self?.bindDataToVc()
//            }, onError: { [weak self] error in
//                self?.errorSubject.onNext(error)
//            })
//            .disposed(by: disposeBag)
//    }
//    
//    func getAllVariantItems() {
        service.makeAPICall(method: .get, endpoint: K.Endpoint.Product.product, byId: nil, itemData: nil)
            .flatMap { data -> Observable<ProductResponse> in
                if let productResponse: ProductResponse = Utils.decode(from: data) {
                    return Observable.just(productResponse)
                } else {
                    return Observable.error(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode product response"]))
                }
            }
            .subscribe(onNext: { [weak self] response in
                let items = response.products?.compactMap{ product in
                    product.variants?.compactMap{ variant in
                        InventoryLevel(available: variant?.inventoryQuantity, inventoryItemId: variant?.inventoryItemID ?? 0, inventoryManagement: variant?.inventoryManagement, title: product.title, variant: variant?.title, price: variant?.price, imageSrc: product.image?.src)
                    }
                }.flatMap { $0 } ?? []
                
                self?.inventoryLevelResponse = InventoryLevelResponse(inventoryLevels: items)
                self?.bindDataToVc()
            }, onError: { [weak self] error in
                self?.errorSubject.onNext(error)
            })
            .disposed(by: disposeBag)
    }
    
    func getItem(byId id: Int64) {
        service.makeAPICall(method: .get, endpoint: "\(K.Endpoint.Inventory.inventoryItem)", byId: id, itemData: nil)
            .flatMap { data -> Observable<InventoryLevelResponse> in
                if let InventoryLevelResponse: InventoryLevelResponse = Utils.decode(from: data) {
                    return Observable.just(InventoryLevelResponse)
                } else {
                    return Observable.error(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode product response"]))
                }
            }
            .subscribe(onNext: { [weak self] product in
                self?.inventoryLevelResponse = product
                self?.bindDataToVc()
            }, onError: { [weak self] error in
                self?.errorSubject.onNext(error)
            })
            .disposed(by: disposeBag)
    }
    
    func updateItem(itemData: InventoryLevel) {
        if let jsonData = Utils.encode(itemData) {
            service.makeAPICall(method: .post, endpoint: K.Endpoint.Inventory.setInventoryItem, byId: itemData.inventoryItemId, itemData: jsonData)
                .flatMap { data -> Observable<InventoryLevelResponse> in
                    if let InventoryLevelResponse: InventoryLevelResponse = Utils.decode(from: data) {
                        return Observable.just(InventoryLevelResponse)
                    } else {
                        return Observable.error(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode product response"]))
                    }
                }
                .subscribe(onNext: { [weak self] product in
                    self?.inventoryLevelResponse = product
                    self?.bindDataToVc()
                }, onError: { [weak self] error in
                    self?.errorSubject.onNext(error)
                })
                .disposed(by: disposeBag)
        } else {
            errorSubject.onNext(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode product data"]))
        }
    }
}
