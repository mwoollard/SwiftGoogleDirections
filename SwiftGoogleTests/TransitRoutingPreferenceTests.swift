//
//  TransitRoutingPreferenceTests.swift
//  SwiftGoogle
//
//  Created by Mark Woollard on 22/02/2016.
//  Copyright © 2016 Mark Woollard. All rights reserved.
//

import XCTest

@testable import SwiftGoogleDirections

class TransitRoutingPreferenceTests: XCTestCase {

    func testURLFragments() {
        
        XCTAssertEqual("fewer_transfers", TransitRoutingPreference.FewerTransfers.urlFragment)
        XCTAssertEqual("less_walking", TransitRoutingPreference.LessWalking.urlFragment)
    }
    
    func testPerformanceExample() {
        self.measureBlock {
            (0..<10000).forEach { _ in
                let _ = TransitRoutingPreference.FewerTransfers.urlFragment
                let _ = TransitRoutingPreference.LessWalking.urlFragment
            }
        }
    }
}
