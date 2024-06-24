//
//  Models.swift
//  SwiftCart Admin
//
//  Created by Mac on 31/05/2024.
//

import Foundation

struct ProductResponse: Codable {
    var errors: String?
    var product: ProductDetail?
    var products: [ProductDetail]?
}

struct ProductDetail: Codable {
    var id: Int64?

    var title: String?
    var bodyHTML: String?
    var vendor: String?
    var productType: String?
    var createdAt: String?
    var handle: String?
    var updatedAt: String?
    var publishedAt: String?
    var templateSuffix: String?
    var publishedScope: String?
    var tags: String?
    var status: String?
    var variants: [ProductVariant?]?
    var options: [ProductOption?]?
    var images: [ProductImage?]?
    var image: ProductImage?
 
    enum CodingKeys: String, CodingKey {
        case id, title
        case bodyHTML = "body_html"
        case vendor
        case productType = "product_type"
        case createdAt = "created_at"
        case handle
        case updatedAt = "updated_at"
        case publishedAt = "published_at"
        case templateSuffix = "template_suffix"
        case publishedScope = "published_scope"
        case tags, status
        case variants, options, images, image
    }
}

struct ProductVariant: Codable {
    var id: Int64?
    var productID: Int64?
    var title: String?
    var price: String?
    var sku: String?
    var position: Int?
    var inventoryPolicy: String?
    var compareAtPrice: String?
    var fulfillmentService: String?
    var inventoryManagement: String?
    var option1: String?
    var option2: String?
    var option3: String?
    var createdAt: String?
    var updatedAt: String?
    var taxable: Bool?
    var barcode: String?
    var grams: Int?
    var weight: Double?
    var weightUnit: String?
    var inventoryItemID: Int64?
    var inventoryQuantity: Int?
    var oldInventoryQuantity: Int?
    var requiresShipping: Bool?
    var imageID: Int64?
 
    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case title, price, sku, position
        case inventoryPolicy = "inventory_policy"
        case compareAtPrice = "compare_at_price"
        case fulfillmentService = "fulfillment_service"
        case inventoryManagement = "inventory_management"
        case option1, option2, option3
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case taxable, barcode, grams, weight
        case weightUnit = "weight_unit"
        case inventoryItemID = "inventory_item_id"
        case inventoryQuantity = "inventory_quantity"
        case oldInventoryQuantity = "old_inventory_quantity"
        case requiresShipping = "requires_shipping"
        case imageID = "image_id"
    }
}

struct ProductOption: Codable {
    var id: Int64?
    var productID: Int64?
    var name: String?
    var position: Int?
    var values: [String]?
 
    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case name, position, values
    }
}

struct ProductImage: Codable {
    var id: Int64?
    var alt: String?
    var position: Int?
    var productID: Int64?
    var createdAt: String?
    var updatedAt: String?
    var width: Int?
    var height: Int?
    var src: String?
    var variantIDS: [Int64]?
 
    enum CodingKeys: String, CodingKey {
        case id, alt, position
        case productID = "product_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case width, height, src
        case variantIDS = "variant_ids"
    }
}
