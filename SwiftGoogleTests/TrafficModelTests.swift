//
//  TrafficModelTests.swift
//  SwiftGoogle
//
//  Created by Mark Woollard on 22/02/2016.
//  Copyright © 2016 Mark Woollard. All rights reserved.
//

import XCTest

@testable import SwiftGoogleDirections

class TrafficModelTests: XCTestCase {

    func testURLFragments() {
        
        XCTAssertEqual("best_guess", TrafficModel.BestGuess.urlFragment)
        XCTAssertEqual("pessimistic", TrafficModel.Pessimistic.urlFragment)
        XCTAssertEqual("optimistic", TrafficModel.Optimistic.urlFragment)
    }
    
    func testPerformanceExample() {
        self.measureBlock {
            (0..<10000).forEach { _ in
                let _ = TrafficModel.BestGuess.urlFragment
                let _ = TrafficModel.Pessimistic.urlFragment
                let _ = TrafficModel.Optimistic.urlFragment
            }
        }
    }
}
