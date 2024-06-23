//
//  Remote.swift
//  SwiftCart Admin
//
//  Created by Mac on 31/05/2024.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire

protocol Servicing {
    func makeAPICall(method: HTTPMethod, endpoint: String, byId: Int64?, itemData: Data?) -> Observable<Data>
}

class RemoteService: Servicing{
    
    private let baseURL = "https://mad44-sv-iost1.myshopify.com/admin/api/2024-04/"
    private let headers: HTTPHeaders = [
        "X-Shopify-Access-Token": "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",
        "Content-Type": "application/json"
    ]
    
    func makeAPICall(method: HTTPMethod, endpoint: String, byId: Int64? = nil, itemData: Data? = nil) -> Observable<Data> {
        
        var endpoint = endpoint
        
        if let byId{
            endpoint = endpoint.replacingOccurrences(of: "{ItemId}", with: "\(byId)")
        }
        
        var url = baseURL + endpoint
        var parameters: [String: Any]? = nil
        
        if let itemData {
            do {
                parameters = try JSONSerialization.jsonObject(with: itemData, options: []) as? [String: Any]
            } catch {
                print("Error encoding product data")
                return Observable.error(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Error encoding product data"]))
            }
        }
        
        return RxAlamofire.request(method, url, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData()
            .map { response, data in
                return data
            }
    }
}
