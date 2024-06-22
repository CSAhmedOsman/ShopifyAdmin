//
// RemoteServiceTests.swift
// SwiftCart Admin Tests
//
//  Created by Mac on 22/06/2024.
//

import XCTest

final class SwiftCart_AdminTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
//
//
//import XCTest
//import RxSwift
//import RxBlocking
//import OHHTTPStubs
//@testable import SwiftCart_Admin
//
//class RemoteServiceTests: XCTestCase {
//    
//    var service: RemoteService!
//    var disposeBag: DisposeBag!
//    
//    override func setUp() {
//        super.setUp()
//        service = RemoteService()
//        disposeBag = DisposeBag()
//    }
//    
//    override func tearDown() {
//        OHHTTPStubs.removeAllStubs()
//        service = nil
//        disposeBag = nil
//        super.tearDown()
//    }
//    
//    func testMakeAPICall_Success() {
//        // Arrange
//        let expectation = self.expectation(description: "API call succeeds")
//        
//        stub(condition: isPath("/admin/api/2024-04/testEndpoint")) { _ in
//            let stubData = "Success".data(using: .utf8)!
//            return HTTPStubsResponse(data: stubData, statusCode: 200, headers: nil)
//        }
//        
//        // Act
//        let result = service.makeAPICall(method: .get, endpoint: "testEndpoint")
//            .toBlocking(timeout: 5)
//            .materialize()
//        
//        // Assert
//        switch result {
//        case .completed(elements: let elements):
//            XCTAssertEqual(elements.first, "Success".data(using: .utf8))
//            expectation.fulfill()
//        case .failed(_, let error):
//            XCTFail("Expected successful response, but got error: \(error)")
//        }
//        
//        waitForExpectations(timeout: 5, handler: nil)
//    }
//    
//    func testMakeAPICall_Failure() {
//        // Arrange
//        let expectation = self.expectation(description: "API call fails")
//        
//        stub(condition: isPath("/admin/api/2024-04/testEndpoint")) { _ in
//            return HTTPStubsResponse(error: NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Internal Server Error"]))
//        }
//        
//        // Act
//        let result = service.makeAPICall(method: .get, endpoint: "testEndpoint")
//            .toBlocking(timeout: 5)
//            .materialize()
//        
//        // Assert
//        switch result {
//        case .completed:
//            XCTFail("Expected error response, but got successful completion")
//        case .failed(_, let error):
//            XCTAssertEqual((error as NSError).code, 500)
//            XCTAssertEqual((error as NSError).localizedDescription, "Internal Server Error")
//            expectation.fulfill()
//        }
//        
//        waitForExpectations(timeout: 5, handler: nil)
//    }
//    
//    func testMakeAPICall_WithProductData_Success() {
//        // Arrange
//        let expectation = self.expectation(description: "API call with product data succeeds")
//        let productData = """
//        {
//            "name": "Test Product",
//            "price": 19.99
//        }
//        """.data(using: .utf8)
//        
//        stub(condition: isPath("/admin/api/2024-04/testEndpoint")) { request in
//            guard let httpBody = request.ohhttpStubs_httpBody,
//                  let json = try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: Any] else {
//                return HTTPStubsResponse(error: NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Bad Request"]))
//            }
//            
//            XCTAssertEqual(json["name"] as? String, "Test Product")
//            XCTAssertEqual(json["price"] as? Double, 19.99)
//            
//            let stubData = "Success".data(using: .utf8)!
//            return HTTPStubsResponse(data: stubData, statusCode: 200, headers: nil)
//        }
//        
//        // Act
//        let result = service.makeAPICall(method: .post, endpoint: "testEndpoint", productData: productData)
//            .toBlocking(timeout: 5)
//            .materialize()
//        
//        // Assert
//        switch result {
//        case .completed(elements: let elements):
//            XCTAssertEqual(elements.first, "Success".data(using: .utf8))
//            expectation.fulfill()
//        case .failed(_, let error):
//            XCTFail("Expected successful response, but got error: \(error)")
//        }
//        
//        waitForExpectations(timeout: 5, handler: nil)
//    }
//    
//    func testMakeAPICall_ErrorEncodingProductData() {
//        // Arrange
//        let expectation = self.expectation(description: "API call with invalid product data fails")
//        let invalidProductData = "Invalid Data".data(using: .utf8)
//        
//        // Act
//        let result = service.makeAPICall(method: .post, endpoint: "testEndpoint", productData: invalidProductData)
//            .toBlocking(timeout: 5)
//            .materialize()
//        
//        // Assert
//        switch result {
//        case .completed:
//            XCTFail("Expected error response, but got successful completion")
//        case .failed(_, let error):
//            XCTAssertEqual((error as NSError).code, 1)
//            XCTAssertEqual((error as NSError).localizedDescription, "Error encoding product data")
//            expectation.fulfill()
//        }
//        
//        waitForExpectations(timeout: 5, handler: nil)
//    }
//}
