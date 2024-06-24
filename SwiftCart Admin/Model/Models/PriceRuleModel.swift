//
//  PriceRuleModel.swift
//  SwiftCart Admin
//
//  Created by Mac on 21/06/2024.
//

import Foundation

struct PriceRuleResponse: Codable {
    var priceRule: PriceRule?
    var priceRules: [PriceRule]?
    enum CodingKeys: String, CodingKey {
        case priceRule = "price_rule"
        case priceRules = "price_rules"
    }
}

struct PriceRule: Codable {
    var id: Int64?
    var valueType: String?
    var value: String?
    var customerSelection: String? = "all"
    var targetType: String?
    var targetSelection: String? = "all"
    var allocationMethod: String?
    var allocationLimit: Int?
    var oncePerCustomer: Bool?
    var usageLimit: Int?
    var startsAt: String?
    var endsAt: String?
    var title: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case valueType = "value_type"
        case value
        case customerSelection = "customer_selection"
        case targetType = "target_type"
        case targetSelection = "target_selection"
        case allocationMethod = "allocation_method"
        case allocationLimit = "allocation_limit"
        case oncePerCustomer = "once_per_customer"
        case usageLimit = "usage_limit"
        case startsAt = "starts_at"
        case endsAt = "ends_at"
        case title
    }
}
