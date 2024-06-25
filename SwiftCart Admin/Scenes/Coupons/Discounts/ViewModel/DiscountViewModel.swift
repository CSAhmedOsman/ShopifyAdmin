//
//  DiscountViewModel.swift
//  SwiftCart Admin
//
//  Created by Mac on 25/06/2024.
//

import Foundation
import RxSwift
import RxCocoa

class DiscountViewModel{
    
    var discountCodeResponse: DiscountCodeResponse? = nil
    private var priceRuleId: Int64
    
    private var service: Servicing
    private let disposeBag = DisposeBag()
    
    // Expose a driver for details
    var bindDataToVc: () -> () = {}
    var bindDeleteDataFromVc: () -> () = {}
    
    // Expose a driver for errors
    private let errorSubject = PublishSubject<Error>()
    var errorDriver: Driver<Error> {
        return errorSubject.asDriver(onErrorDriveWith: .empty())
    }
    
    init(priceRuleId: Int64, service: Servicing) {
        self.priceRuleId = priceRuleId
        self.service = service
    }
    
    func getAllItems(){
        service.makeAPICall(method: .get, endpoint: K.Endpoint.Coupons.discountCodes, byId: priceRuleId, itemData: nil)
            .flatMap { data -> Observable<DiscountCodeResponse> in
                if let DiscountCodeResponse: DiscountCodeResponse = Utils.decode(from: data) {
                    return Observable.just(DiscountCodeResponse)
                } else {
                    return Observable.error(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode data response"]))
                }
            }
            .subscribe(onNext: { [weak self] response in
                self?.discountCodeResponse = response
                self?.bindDataToVc()
            }, onError: { [weak self] error in
                self?.errorSubject.onNext(error)
            })
            .disposed(by: disposeBag)
    }
    
    func addItem(itemData: DiscountCode) {
        let request = DiscountCodeResponse(discountCode: itemData)
        if let jsonData = Utils.encode(request) {
            service.makeAPICall(method: .post, endpoint: K.Endpoint.Coupons.discountCodes, byId: priceRuleId, itemData: jsonData)
                .flatMap { data -> Observable<DiscountCodeResponse> in
                    if let DiscountCodeResponse: DiscountCodeResponse = Utils.decode(from: data) {
                        return Observable.just(DiscountCodeResponse)
                    } else {
                        return Observable.error(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode data response"]))
                    }
                }
                .subscribe(onNext: { [weak self] response in
                    self?.discountCodeResponse = response
                    self?.bindDataToVc()
                }, onError: { [weak self] error in
                    self?.errorSubject.onNext(error)
                })
                .disposed(by: disposeBag)
        } else {
            errorSubject.onNext(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode data data"]))
        }
    }
    
    func updateItem(itemData: DiscountCode) {
        let endpoint = K.Endpoint.Coupons.discountCodeDetail.replacingOccurrences(of: "{DetailId}", with: "\(itemData.id ?? 0)")
        let request = DiscountCodeResponse(discountCode: itemData)
        if let jsonData = Utils.encode(request) {
            service.makeAPICall(method: .put, endpoint: endpoint, byId: priceRuleId, itemData: jsonData)
                .flatMap { data -> Observable<DiscountCodeResponse> in
                    if let DiscountCodeResponse: DiscountCodeResponse = Utils.decode(from: data) {
                        return Observable.just(DiscountCodeResponse)
                    } else {
                        return Observable.error(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode data response"]))
                    }
                }
                .subscribe(onNext: { [weak self] response in
                    self?.discountCodeResponse = response
                    self?.bindDataToVc()
                }, onError: { [weak self] error in
                    self?.errorSubject.onNext(error)
                })
                .disposed(by: disposeBag)
        } else {
            errorSubject.onNext(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode data data"]))
        }
    }
    
    func deleteItem(at id: Int64) {
        let endpoint = K.Endpoint.Coupons.discountCodeDetail.replacingOccurrences(of: "{DetailId}", with: "\(id)")
        service.makeAPICall(method: .delete, endpoint: endpoint, byId: priceRuleId, itemData: nil)
            .subscribe(onNext: { [weak self] _ in
                self?.discountCodeResponse?.discountCodes?.removeAll(where: { response in
                    response.id == id
                })
                self?.bindDeleteDataFromVc()
            }, onError: { [weak self] error in
                self?.errorSubject.onNext(error)
            })
            .disposed(by: disposeBag)
    }
}
