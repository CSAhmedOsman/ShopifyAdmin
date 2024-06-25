//
// RemoteServiceTests.swift
// SwiftCart Admin Tests
//
//  Created by Mac on 22/06/2024.
//

import XCTest
import RxSwift
@testable import SwiftCart_Admin

class RemoteServiceTests: XCTestCase {
    
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
    
    func testMakeAPICall_Success_WithAllItemData() {
        // Arrange
        let expectation = self.expectation(description: "API call succeeds")
        
        // Act
        let result = service.makeAPICall(method: .get, endpoint: K.Endpoint.Coupons.priceRules, byId: nil, itemData: nil)
        
        // Assert
        result.subscribe { data in
            let rule: PriceRuleResponse? = Utils.decode(from: data)
            XCTAssertEqual(rule?.priceRules?.count, 4)
            expectation.fulfill()
        } onError: { error in
            XCTFail("Expected successful response, but got error: \(error)")
        }.disposed(by: disposeBag)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testMakeAPICall_Failure() {
        // Arrange
        let expectation = self.expectation(description: "API call Failure")
        
        // Act
        let result = service.makeAPICall(method: .get, endpoint: K.Endpoint.Coupons.priceRuleDetails, byId: 0, itemData: nil)
        
        // Assert
        result.subscribe { data in
            let rule: PriceRuleResponse? = Utils.decode(from: data)
            XCTFail("Expected Fail response, but got successful")
        } onError: { error in
            XCTAssertTrue(true)
            expectation.fulfill()
        }.disposed(by: disposeBag)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testMakeAPICall_Success_WithItemData() {
        // Arrange
        let expectation = self.expectation(description: "API call succeeds")
        let id: Int64 = 1098887004207
        
        // Act
        let result = service.makeAPICall(method: .get, endpoint: K.Endpoint.Coupons.priceRuleDetails, byId: id, itemData: nil)
        
        // Assert
        result.subscribe { data in
            let rule: PriceRuleResponse? = Utils.decode(from: data)
            XCTAssertEqual(rule?.priceRule?.id, id)
            expectation.fulfill()
        } onError: { error in
            XCTFail("Expected successful response, but got error: \(error)")
        }.disposed(by: disposeBag)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testMakeAPICall_Success_WithAddItem() {
        // Arrange
        let expectation = self.expectation(description: "API call succeeds")
        var request = TestHelper.getItem()
        request?.priceRule?.id = nil
        
        let data = Utils.encode(request)
        
        // Act
        let result = service.makeAPICall(method: .post, endpoint: K.Endpoint.Coupons.priceRules, byId: nil, itemData: data)
        
        // Assert
        result.subscribe { data in
            let rule: PriceRuleResponse? = Utils.decode(from: data)
            XCTAssertEqual(rule?.priceRule?.title, request?.priceRule?.title)
            expectation.fulfill()
        } onError: { error in
            XCTFail("Expected successful response, but got error: \(error)")
        }.disposed(by: disposeBag)
        
        waitForExpectations(timeout: 15, handler: nil)
    }  
    
    func testMakeAPICall_Fail_WithAddItem() {
        // Arrange
        let expectation = self.expectation(description: "API call succeeds")
        var request = TestHelper.getItem()
        request?.priceRule?.id = nil
        
        let data = Utils.encode(request)
        
        // Act
        let result = service.makeAPICall(method: .post, endpoint: K.Endpoint.Coupons.priceRules, byId: nil, itemData: nil)
        
        // Assert
        result.subscribe { data in
            XCTFail("Expected Fail response, but got successful")
        } onError: { error in
            XCTAssertTrue(true)
            expectation.fulfill()
        }.disposed(by: disposeBag)
        
        waitForExpectations(timeout: 15, handler: nil)
    }
    
    func testMakeAPICall_Success_WithUpdataItem() {
        // Arrange
        let expectation = self.expectation(description: "API call succeeds")
        let id: Int64 = 1099056087087
        var request = TestHelper.getItem()
        let jsonData = Utils.encode(request)
        
        // Act
        let result = service.makeAPICall(method: .put, endpoint: K.Endpoint.Coupons.priceRuleDetails, byId: id, itemData: jsonData)
        
        // Assert
        result.subscribe { data in
            let rule: PriceRuleResponse? = Utils.decode(from: data)
            XCTAssertEqual(rule?.priceRule?.id, id)
            expectation.fulfill()
        } onError: { error in
            XCTFail("Expected successful response, but got error: \(error)")
        }.disposed(by: disposeBag)
        
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testMakeAPICall_Success_WithDeleteItem() {
        // Arrange
        let expectation = self.expectation(description: "API call succeeds")
        var id: Int64 = 0
        var request = TestHelper.getItem()
        request?.priceRule?.id = nil
        
        let data = Utils.encode(request)
        
        // Act
        let result = service.makeAPICall(method: .post, endpoint: K.Endpoint.Coupons.priceRules, byId: nil, itemData: data)
        
        // Assert
        result.subscribe { data in
            let rule: PriceRuleResponse? = Utils.decode(from: data)
            id = rule?.priceRule?.id ?? 0
            
            let result = self.service.makeAPICall(method: .delete, endpoint: K.Endpoint.Coupons.priceRuleDetails, byId: id, itemData: nil)

            // Assert
            result.subscribe { data in
                let rule: PriceRuleResponse? = Utils.decode(from: data)
                XCTAssertEqual(rule?.priceRule?.title, nil)
                expectation.fulfill()
            } onError: { error in
                XCTFail("Expected successful response, but got error: \(error)")
            }.disposed(by: self.disposeBag)
            
            
        } onError: { error in
            XCTFail("Expected successful response, but got error: \(error)")
        }.disposed(by: disposeBag)
        
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testMakeAPICall_Fail_WithDeleteItem() {
        // Arrange
        let expectation = self.expectation(description: "API call succeeds")
        let id: Int64 = 0
        
        // Act
        let result = service.makeAPICall(method: .delete, endpoint: K.Endpoint.Coupons.priceRuleDetails, byId: id, itemData: nil)
        
        // Assert
        result.subscribe { data in
            XCTFail("Expected Fail response, but got successful")
        } onError: { error in
            XCTAssertTrue(true)
            expectation.fulfill()
        }.disposed(by: disposeBag)
        
        waitForExpectations(timeout: 15, handler: nil)
    }

}

class TestHelper{
    
    static func getItem() -> PriceRuleResponse?{
        // Convert JSON string to Data
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("Failed to convert JSON string to Data")
            return nil
        }
        
        return Utils.decode(from: jsonData)
    }
    
    // JSON string
    private static let jsonString = """
        {
            "price_rule": {
                "title": "15OFF",
                "value_type": "percentage",
                "value": "-15.0",
                "customer_selection": "all",
                "target_type": "line_item",
                "target_selection": "all",
                "allocation_method": "across",
                "starts_at": "2017-01-19T17:59:10Z"
            }
        }
        """
}

