//
//  WaypointTimeTests.swift
//  SwiftGoogle
//
//  Created by Mark Woollard on 22/02/2016.
//  Copyright © 2016 Mark Woollard. All rights reserved.
//

import XCTest

@testable import SwiftGoogleDirections

class WaypointTimeTests: XCTestCase {

    func testArrivalTime() {
    
        let now = NSDate()
        (0..<10).forEach { _ in
            let offset = arc4random_uniform(10000)
            let testTime = now.dateByAddingTimeInterval(NSTimeInterval(offset))
            let wpt = WaypointTime(arrival: testTime)
            XCTAssertEqual("arrival_time=\(UInt64(testTime.timeIntervalSince1970))", wpt.urlFragment)
        }
    }

    func testDepartureTime() {
        let now = NSDate()
        (0..<10).forEach { _ in
            let offset = arc4random_uniform(10000)
            let testTime = now.dateByAddingTimeInterval(NSTimeInterval(offset))
            let wpt = WaypointTime(departure: testTime)
            XCTAssertEqual("departure_time=\(UInt64(testTime.timeIntervalSince1970))", wpt.urlFragment)
        }
    }

    func testPerformance() {
        self.measureBlock {
            (0..<10000).forEach { _ in
                let _ = WaypointTime(arrival: NSDate())
                let _ = WaypointTime(departure: NSDate())
            }
        }
    }

}
