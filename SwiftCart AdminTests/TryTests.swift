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
    
}
