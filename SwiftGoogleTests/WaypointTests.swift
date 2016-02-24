//
//  WaypointTests.swift
//  SwiftGoogle
//
//  Created by Mark Woollard on 22/02/2016.
//  Copyright © 2016 Mark Woollard. All rights reserved.
//

import XCTest
import CoreLocation

@testable import SwiftGoogleDirections

class WaypointTests: XCTestCase {

    func testAddresses() {
        testAddressesData.forEach { addr in
            XCTAssertEqual(addr, Waypoint(address:addr).urlFragment.stringByRemovingPercentEncoding!)
        }
    }

    func testPlaceIds() {
        testPlaceIdData.forEach { placeId in
            XCTAssertEqual("place_id:\(placeId)", Waypoint(placeID: placeId).urlFragment.stringByRemovingPercentEncoding!)
        }
    }
    
    func testCoordinateLocation() {
        testLocationData.forEach { coord in
            let encoded = Waypoint(coordinateLocation: coord).urlFragment.componentsSeparatedByString(",")
            XCTAssertEqualWithAccuracy(coord.latitude, Double(encoded[0])!, accuracy: 0.000001)
            XCTAssertEqualWithAccuracy(coord.longitude, Double(encoded[1])!, accuracy: 0.000001)
        }
    }
    
    func testPerformance() {
        self.measureBlock {
            (0..<10000).forEach { _ in
                let _ = Waypoint(address: testAddressesData[0]).urlFragment
                let _ = Waypoint(placeID: testPlaceIdData[0]).urlFragment
                let _ = Waypoint(coordinateLocation: testLocationData[0]).urlFragment
            }
        }
    }

}
