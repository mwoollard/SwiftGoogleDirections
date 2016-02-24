//
//  UnitTests.swift
//  SwiftGoogle
//
//  Created by Mark Woollard on 22/02/2016.
//  Copyright © 2016 Mark Woollard. All rights reserved.
//

import XCTest

@testable import SwiftGoogleDirections

class UnitTests: XCTestCase {
    
    func testURLFragments() {
        
        XCTAssertEqual("metric", Units.Metric.urlFragment)
        XCTAssertEqual("imperial", Units.Imperial.urlFragment)
    }
    
    func testPerformanceExample() {
        self.measureBlock {
            (0..<10000).forEach { _ in
                let _ = Units.Metric.urlFragment
                let _ = Units.Imperial.urlFragment
            }
        }
    }
}
