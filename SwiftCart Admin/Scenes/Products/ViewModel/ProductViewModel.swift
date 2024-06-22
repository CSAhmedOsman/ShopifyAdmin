//
//  ProductViewModel.swift
//  SwiftCart Admin
//
//  Created by Mac on 21/06/2024.
//

import Foundation
import RxSwift
import RxCocoa

class ProductViewModel: ViewModeling {
    typealias T = ProductResponse?
    
    var productResponse: ProductResponse? = nil
    
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
    
    func addItem(itemData: ProductResponse?) {
        if let jsonData = Utils.encode(itemData) {
            service.makeAPICall(method: .post, endpoint: K.Endpoint.product, productData: jsonData)
                .flatMap { data -> Observable<ProductResponse> in
                    if let productResponse: ProductResponse = Utils.decode(from: data) {
                        return Observable.just(productResponse)
                    } else {
                        return Observable.error(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode product response"]))
                    }
                }
                .subscribe(onNext: { [weak self] product in
                    self?.productResponse = product
                    self?.bindDataToVc()
                }, onError: { [weak self] error in
                    self?.errorSubject.onNext(error)
                })
                .disposed(by: disposeBag)
        } else {
            errorSubject.onNext(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode product data"]))
        }
    }
    
    func getAllItems() {
        service.makeAPICall(method: .get, endpoint: K.Endpoint.product, productData: nil)
            .flatMap { data -> Observable<ProductResponse> in
                if let productResponse: ProductResponse = Utils.decode(from: data) {
                    return Observable.just(productResponse)
                } else {
                    return Observable.error(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode product response"]))
                }
            }
            .subscribe(onNext: { [weak self] product in
                self?.productResponse = product
                self?.bindDataToVc()
            }, onError: { [weak self] error in
                self?.errorSubject.onNext(error)
            })
            .disposed(by: disposeBag)
    }
    
    func getItem(byId id: Int64) {
        service.makeAPICall(method: .get, endpoint: "\(K.Endpoint.product)/\(id).json", productData: nil)
            .flatMap { data -> Observable<ProductResponse> in
                if let productResponse: ProductResponse = Utils.decode(from: data) {
                    return Observable.just(productResponse)
                } else {
                    return Observable.error(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode product response"]))
                }
            }
            .subscribe(onNext: { [weak self] product in
                self?.productResponse = product
                self?.bindDataToVc()
            }, onError: { [weak self] error in
                self?.errorSubject.onNext(error)
            })
            .disposed(by: disposeBag)
    }
    
    func updateItem(itemData: ProductResponse?) {
        if let jsonData = Utils.encode(itemData) {
            service.makeAPICall(method: .put, endpoint: "\(K.Endpoint.product)/\(itemData?.product?.id ?? 0).json", productData: jsonData)
                .flatMap { data -> Observable<ProductResponse> in
                    if let productResponse: ProductResponse = Utils.decode(from: data) {
                        return Observable.just(productResponse)
                    } else {
                        return Observable.error(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode product response"]))
                    }
                }
                .subscribe(onNext: { [weak self] product in
                    self?.productResponse = product
                    self?.bindDataToVc()
                }, onError: { [weak self] error in
                    self?.errorSubject.onNext(error)
                })
                .disposed(by: disposeBag)
        } else {
            errorSubject.onNext(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode product data"]))
        }
    }
    
    func deleteItem(at: Int64) {
        let id = productResponse?.products?[Int(at)].id ?? 0
        let endpoint = "\(K.Endpoint.product)/\(id).json"
        service.makeAPICall(method: .delete, endpoint: endpoint, productData: nil)
            .subscribe(onNext: { [weak self] _ in
                self?.productResponse = nil
                self?.productResponse?.products?.remove(at: Int(at))
                self?.bindDeleteDataFromVc()
            }, onError: { [weak self] error in
                self?.errorSubject.onNext(error)
            })
            .disposed(by: disposeBag)
    }
}