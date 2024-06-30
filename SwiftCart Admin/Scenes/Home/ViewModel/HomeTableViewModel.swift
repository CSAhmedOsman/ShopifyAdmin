//
//  HomeTableViewModel.swift
//  SwiftCart Admin
//
//  Created by Mac on 26/06/2024.
//

import Foundation
import RxSwift
import RxCocoa

class HomeTableViewModel{
            
    private var service: Servicing
    private let disposeBag = DisposeBag()
    
    // Expose a driver for errors
    private let errorSubject = PublishSubject<Error>()
    var errorDriver: Driver<Error> {
        return errorSubject.asDriver(onErrorDriveWith: .empty())
    }
    
    init(service: Servicing) {
        self.service = service
    }
    
    struct Counter: Codable {
        var count: Int?
    }
    
    func getCount(endpoint: String, complation: @escaping (Int) -> ()) {
        service.makeAPICall(method: .get, endpoint: endpoint, byId: nil, itemData: nil)
            .flatMap { data -> Observable<Counter> in
                if let counter: Counter = Utils.decode(from: data) {
                    return Observable.just(counter)
                } else {
                    return Observable.error(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode product response"]))
                }
            }
            .subscribe(onNext: { response in
                complation(response.count ?? 0)
            }, onError: { [weak self] error in
                self?.errorSubject.onNext(error)
            })
            .disposed(by: disposeBag)
    }
    
}
