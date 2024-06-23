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
    
    func testMakeAPICall_Success_WithProductData() {
        // Arrange
        let expectation = self.expectation(description: "API call succeeds")
        
        // Act
        let result = service.makeAPICall(method: .get, endpoint: K.Endpoint.productDetail, byId: 7680318832687, itemData: nil)
        
        // Assert
        result.subscribe { data in
            let product: ProductResponse? = Utils.decode(from: data)
            //            print(product)
            //            print(TestHelper.getProduct())
            XCTAssertEqual(product?.product?.id,TestHelper.getProduct()?.product?.id)
            expectation.fulfill()
            //            print("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-")
        } onError: { error in
            XCTFail("Expected successful response, but got error: \(error)")
        }.disposed(by: disposeBag)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testMakeAPICall_Failure() {
        // Arrange
        let expectation = self.expectation(description: "API call succeeds")
        
        // Act
        let result = service.makeAPICall(method: .get, endpoint: K.Endpoint.productDetail, byId: 0, itemData: nil)
        
        // Assert
        result.subscribe { data in
            XCTFail("Expected successful response, but got Response")
        } onError: { error in
            print("Error: \(error)")
            XCTAssertEqual(error.asAFError?.responseCode, 404)
            expectation.fulfill()
        }.disposed(by: disposeBag)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testMakeAPICall_Success_WithAllProducts() {
        // Arrange
        let expectation = self.expectation(description: "API call succeeds")
        
        // Act
        let result = service.makeAPICall(method: .get, endpoint: K.Endpoint.product, byId: nil, itemData: nil)
        
        // Assert
        result.subscribe { data in
            let product: ProductResponse? = Utils.decode(from: data)
            //            print(product)
            //            print(TestHelper.getProduct())
            XCTAssertEqual(product?.products?.count, 29)
            expectation.fulfill()
            //            print("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-")
        } onError: { error in
            XCTFail("Expected successful response, but got error: \(error)")
        }.disposed(by: disposeBag)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testMakeAPICall_Success_WithAddProduct() {
        // Arrange
        let expectation = self.expectation(description: "API call succeeds")
        var productRequest = TestHelper.getProduct()
        productRequest?.errors = nil
        productRequest?.product?.id = nil
        
        let productData = Utils.encode(productRequest)
        
        // Act
        let result = service.makeAPICall(method: .post, endpoint: K.Endpoint.product, byId: nil, itemData: productData)
        
        // Assert
        result.subscribe { data in
            let product: ProductResponse? = Utils.decode(from: data)
            XCTAssertEqual(product?.product?.title, productRequest?.product?.title)
            expectation.fulfill()
        } onError: { error in
            XCTFail("Expected successful response, but got error: \(error)")
        }.disposed(by: disposeBag)
        
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testMakeAPICall_Success_WithDeleteProduct() {
        // Arrange
        let expectation = self.expectation(description: "API call succeeds")

        // Act
        let result = service.makeAPICall(method: .delete, endpoint: K.Endpoint.productDetail, byId: 7740094611503, itemData: nil)
        
        // Assert
        result.subscribe { data in
            let product: ProductResponse? = Utils.decode(from: data)
            XCTAssertEqual(product?.errors, nil)
            expectation.fulfill()
        } onError: { error in
            XCTFail("Expected successful response, but got error: \(error)")
        }.disposed(by: disposeBag)
        
        waitForExpectations(timeout: 15, handler: nil)
    }
    
}

class TestHelper{
    
    static func getProduct() -> ProductResponse?{
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
            "errors": "Not Found",
            "product": {
                "id": 7680318832687,
                "title": "ADIDAS | CLASSIC BACKPACK | LEGEND INK MULTICOLOUR",
                "body_html": "The adidas BP Classic Cap features a pre-curved brim to keep your face shaded, while a hook-and-loop adjustable closure provides a comfortable fit. With a 3-Stripes design and reflective accents. The perfect piece to top off any outfit.",
                "vendor": "ADIDAS",
                "product_type": "ACCESSORIES",
                "created_at": "2024-05-27T08:19:02-04:00",
                "handle": "adidas-classic-backpack-legend-ink-multicolour",
                "updated_at": "2024-05-27T08:20:05-04:00",
                "published_at": "2024-05-27T08:19:02-04:00",
                "template_suffix": null,
                "published_scope": "global",
                "tags": "adidas, backpack, egnition-sample-data",
                "status": "active",
                "admin_graphql_api_id": "gid://shopify/Product/7680318832687",
                "variants": [
                    {
                        "id": 42871034871855,
                        "product_id": 7680318832687,
                        "title": "OS / blue",
                        "price": "50.00",
                        "sku": "AD-04\\r\\n-blue-OS",
                        "position": 1,
                        "inventory_policy": "deny",
                        "compare_at_price": null,
                        "fulfillment_service": "manual",
                        "inventory_management": "shopify",
                        "option1": "OS",
                        "option2": "blue",
                        "option3": null,
                        "created_at": "2024-05-27T08:19:02-04:00",
                        "updated_at": "2024-05-27T08:20:05-04:00",
                        "taxable": true,
                        "barcode": null,
                        "grams": 0,
                        "weight": 0.0,
                        "weight_unit": "kg",
                        "inventory_item_id": 44966381420591,
                        "inventory_quantity": 6,
                        "old_inventory_quantity": 6,
                        "requires_shipping": true,
                        "admin_graphql_api_id": "gid://shopify/ProductVariant/42871034871855",
                        "image_id": null
                    }
                ],
                "options": [
                    {
                        "id": 9744878174255,
                        "product_id": 7680318832687,
                        "name": "Size",
                        "position": 1,
                        "values": [
                            "OS"
                        ]
                    },
                    {
                        "id": 9744878239791,
                        "product_id": 7680318832687,
                        "name": "Color",
                        "position": 2,
                        "values": [
                            "blue"
                        ]
                    }
                ],
                "images": [
                    {
                        "id": 33973352759343,
                        "alt": null,
                        "position": 1,
                        "product_id": 7680318832687,
                        "created_at": "2024-05-27T08:19:02-04:00",
                        "updated_at": "2024-05-27T08:19:02-04:00",
                        "admin_graphql_api_id": "gid://shopify/ProductImage/33973352759343",
                        "width": 635,
                        "height": 560,
                        "src": "https://cdn.shopify.com/s/files/1/0624/0239/6207/files/8072c8b5718306d4be25aac21836ce16.jpg?v=1716812342",
                        "variant_ids": []
                    },
                    {
                        "id": 33973352792111,
                        "alt": null,
                        "position": 2,
                        "product_id": 7680318832687,
                        "created_at": "2024-05-27T08:19:02-04:00",
                        "updated_at": "2024-05-27T08:19:02-04:00",
                        "admin_graphql_api_id": "gid://shopify/ProductImage/33973352792111",
                        "width": 635,
                        "height": 560,
                        "src": "https://cdn.shopify.com/s/files/1/0624/0239/6207/files/32b3863554f4686d825d9da18a24cfc6.jpg?v=1716812342",
                        "variant_ids": []
                    },
                    {
                        "id": 33973352824879,
                        "alt": null,
                        "position": 3,
                        "product_id": 7680318832687,
                        "created_at": "2024-05-27T08:19:02-04:00",
                        "updated_at": "2024-05-27T08:19:02-04:00",
                        "admin_graphql_api_id": "gid://shopify/ProductImage/33973352824879",
                        "width": 635,
                        "height": 560,
                        "src": "https://cdn.shopify.com/s/files/1/0624/0239/6207/files/044f848776141f1024eae6c610a28d12.jpg?v=1716812342",
                        "variant_ids": []
                    }
                ],
                "image": {
                    "id": 33973352759343,
                    "alt": null,
                    "position": 1,
                    "product_id": 7680318832687,
                    "created_at": "2024-05-27T08:19:02-04:00",
                    "updated_at": "2024-05-27T08:19:02-04:00",
                    "admin_graphql_api_id": "gid://shopify/ProductImage/33973352759343",
                    "width": 635,
                    "height": 560,
                    "src": "https://cdn.shopify.com/s/files/1/0624/0239/6207/files/8072c8b5718306d4be25aac21836ce16.jpg?v=1716812342",
                    "variant_ids": []
                }
            }
        }
        """
}
