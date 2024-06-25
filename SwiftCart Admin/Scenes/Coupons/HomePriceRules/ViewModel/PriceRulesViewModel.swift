//
//  CouponsViewModel.swift
//  SwiftCart Admin
//
//  Created by Mac on 24/06/2024.
//

import Foundation
import RxSwift
import RxCocoa

class PriceRulesViewModel {
    
    var priceRuleResponse: PriceRuleResponse? = nil
    
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
    
    init(service: Servicing) {
        self.service = service
    }
    
    func getAllItems() {
        service.makeAPICall(method: .get, endpoint: K.Endpoint.Coupons.priceRules, byId: nil, itemData: nil)
            .flatMap { data -> Observable<PriceRuleResponse> in
                if let priceRuleResponse: PriceRuleResponse = Utils.decode(from: data) {
                    return Observable.just(priceRuleResponse)
                } else {
                    return Observable.error(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode data response"]))
                }
            }
            .subscribe(onNext: { [weak self] response in
                self?.priceRuleResponse = response
                self?.bindDataToVc()
            }, onError: { [weak self] error in
                self?.errorSubject.onNext(error)
            })
            .disposed(by: disposeBag)
    }
    
    func addItem(itemData: PriceRule) {
        if let jsonData = Utils.encode(itemData) {
            service.makeAPICall(method: .post, endpoint: K.Endpoint.Coupons.priceRules, byId: nil, itemData: jsonData)
                .flatMap { data -> Observable<PriceRuleResponse> in
                    if let priceRuleResponse: PriceRuleResponse = Utils.decode(from: data) {
                        return Observable.just(priceRuleResponse)
                    } else {
                        return Observable.error(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode data response"]))
                    }
                }
                .subscribe(onNext: { [weak self] response in
                    self?.priceRuleResponse = response
                    self?.bindDataToVc()
                }, onError: { [weak self] error in
                    self?.errorSubject.onNext(error)
                })
                .disposed(by: disposeBag)
        } else {
            errorSubject.onNext(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode data data"]))
        }
    }
    
    func getItem(byId id: Int64) {
        service.makeAPICall(method: .get, endpoint: K.Endpoint.Coupons.priceRuleDetails, byId: id, itemData: nil)
            .flatMap { data -> Observable<PriceRuleResponse> in
                if let priceRuleResponse: PriceRuleResponse = Utils.decode(from: data) {
                    return Observable.just(priceRuleResponse)
                } else {
                    return Observable.error(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode data response"]))
                }
            }
            .subscribe(onNext: { [weak self] response in
                self?.priceRuleResponse = response
                self?.bindDataToVc()
            }, onError: { [weak self] error in
                self?.errorSubject.onNext(error)
            })
            .disposed(by: disposeBag)
    }
    
    func updateItem(itemData: PriceRule) {
        if let jsonData = Utils.encode(itemData) {
            service.makeAPICall(method: .put, endpoint: K.Endpoint.Coupons.priceRuleDetails, byId: itemData.id, itemData: jsonData)
                .flatMap { data -> Observable<PriceRuleResponse> in
                    if let priceRuleResponse: PriceRuleResponse = Utils.decode(from: data) {
                        return Observable.just(priceRuleResponse)
                    } else {
                        return Observable.error(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode data response"]))
                    }
                }
                .subscribe(onNext: { [weak self] response in
                    self?.priceRuleResponse = response
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
        service.makeAPICall(method: .delete, endpoint: K.Endpoint.Coupons.priceRuleDetails, byId: id, itemData: nil)
            .subscribe(onNext: { [weak self] _ in
                self?.priceRuleResponse?.priceRules?.removeAll(where: { response in
                    response.id == id
                })
                self?.bindDeleteDataFromVc()
            }, onError: { [weak self] error in
                self?.errorSubject.onNext(error)
            })
            .disposed(by: disposeBag)
    }
}
