//
//  TransitModeTests.swift
//  SwiftGoogle
//
//  Created by Mark Woollard on 22/02/2016.
//  Copyright © 2016 Mark Woollard. All rights reserved.
//

import XCTest

@testable import SwiftGoogleDirections

class TransitModeTests: XCTestCase {

    func testURLFragments() {
        
        XCTAssertEqual("bus", TransitMode.Bus.urlFragment)
        XCTAssertEqual("train", TransitMode.Train.urlFragment)
        XCTAssertEqual("tram", TransitMode.Tram.urlFragment)
        XCTAssertEqual("subway", TransitMode.Subway.urlFragment)
        XCTAssertEqual("rail", TransitMode.Rail.urlFragment)
    }

    func testPerformanceExample() {
        self.measureBlock {
            (0..<10000).forEach { _ in
                let _ = TransitMode.Bus.urlFragment
                let _ = TransitMode.Train.urlFragment
                let _ = TransitMode.Tram.urlFragment
                let _ = TransitMode.Subway.urlFragment
                let _ = TransitMode.Rail.urlFragment
            }
        }
    }

}
