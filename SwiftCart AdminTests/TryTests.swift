//
//  File.swift
//  SwiftCart AdminTests
//
//  Created by Mac on 25/06/2024.
//

import XCTest
import RxSwift
@testable import SwiftCart_Admin

class TryTests: XCTestCase {
    
    var service: Servicing!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        service = RemoteService()
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        service = nil
        disposeBag = nil
        super.tearDown()
    }
    
    func testMakeAPICall_Success_WithAllItemData(){
        // Arrange
        let expectation = self.expectation(description: "API call succeeds")
        let priceRuleId: Int64 = 1099056087087
        
        // Act
        let result =  service.makeAPICall(method: .get, endpoint: K.Endpoint.Coupons.discountCodes, byId: priceRuleId, itemData: nil)
        
        // Assert
        result.subscribe{ data in
            let discount: DiscountCodeResponse? = Utils.decode(from: data)
            XCTAssertGreaterThan(discount?.discountCodes?.count ?? 0, 0)
            expectation.fulfill()
        } onError: { error in
            XCTFail("Expected successful response, but got error: \(error)")
        }.disposed(by: disposeBag)
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testMakeAPICall_Success_WithAddItemData(){
        // Arrange
        let expectation = self.expectation(description: "API call succeeds")
        let priceRuleId: Int64 = 1099056087087
        let request = DiscountCodeResponse(discountCode: DiscountCode(code: "Test\(Int.random(in: 1000000..<10000000))"))
        let jsonData = Utils.encode(request)
        
        // Act
        let result =  service.makeAPICall(method: .post, endpoint: K.Endpoint.Coupons.discountCodes, byId: priceRuleId, itemData: jsonData)
        
        // Assert
        result.subscribe{ data in
            let discount: DiscountCodeResponse? = Utils.decode(from: data)
            XCTAssertEqual(discount?.discountCode?.code, request.discountCode?.code)
            expectation.fulfill()
        } onError: { error in
            print("Error: \(error.localizedDescription)")
            XCTFail("Expected successful response, but got error: \(error)")
        }.disposed(by: disposeBag)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    

}
