//
//  Remote.swift
//  SwiftCart Admin
//
//  Created by Mac on 31/05/2024.
//

import Foundation

protocol Servicing{
    associatedtype T
    func fetchData(complation: @escaping (T)->())
}

