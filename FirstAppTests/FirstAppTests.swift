//
//  FirstAppTests.swift
//  FirstAppTests
//
//  Created by Philip Gurr on 08.11.20.
//

import XCTest
@testable import FirstApp

class FirstAppTests: XCTestCase {

    // MARK: Meal Class Tests
    func testMealInitializationSucceeds() {
        let meal = Meal.init(name: "hello", photo: nil)
        XCTAssertNotNil(meal)
    }
    
    func testMealInitializationFails() {
        let meal = Meal.init(name: "", photo: nil)
        XCTAssertNil(meal)
    }
}
