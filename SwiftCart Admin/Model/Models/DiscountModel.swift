//
//  DiscountModel.swift
//  SwiftCart Admin
//
//  Created by Mac on 25/06/2024.
//

import Foundation

struct DiscountCodeResponse: Codable {
    var discountCode: DiscountCode?
    var discountCodes: [DiscountCode]?

    enum CodingKeys: String, CodingKey {
        case discountCode = "discount_code"
        case discountCodes = "discount_codes"
    }
}

struct DiscountCodeRequest: Codable {
    var discountCode: DiscountCode

    enum CodingKeys: String, CodingKey {
        case discountCode = "discount_code"
    }
}

struct DiscountCode: Codable {
    var id: Int64?
    var priceRuleId: Int64?
    var code: String?
    var usageCount: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case priceRuleId = "price_rule_id"
        case code
        case usageCount = "usage_count"
    }
}
