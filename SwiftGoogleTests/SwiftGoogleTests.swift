//
//  SwiftGoogleTests.swift
//  SwiftGoogleTests
//
//  Created by Mark Woollard on 18/02/2016.
//  Copyright © 2016 Mark Woollard. All rights reserved.
//

import XCTest
import CoreLocation
import SwiftyJSON

@testable import SwiftGoogleDirections

let GoogleKey = "Provide a valid Google API Key"
let BaseURL = "https://maps.googleapis.com/maps/api/directions/json"

class SwiftGoogleTests: XCTestCase {
    
    func testDefaultsToDriving() {
        let sut = GoogleDirections(key: GoogleKey, origin: Waypoint(address: testAddressesData[0]), destination: Waypoint(address:testAddressesData[1]))
        
        let urlString = sut.urlString
        validateBase(urlString, origin: testAddressesData[0], destination: testAddressesData[1], mode: "driving")
    }
    
    func testDriving() {
        let sut = GoogleDirections(key: GoogleKey, origin: Waypoint(address: testAddressesData[0]), destination: Waypoint(address:testAddressesData[1]), travelMode:Driving())
        
        let urlString = sut.urlString
        validateBase(urlString, origin: testAddressesData[0], destination: testAddressesData[1], mode: "driving")
    }
    
    func testWalking() {
        let sut = GoogleDirections(key: GoogleKey, origin: Waypoint(address: testAddressesData[0]), destination: Waypoint(address:testAddressesData[1]), travelMode:Walking())
        
        let urlString = sut.urlString
        validateBase(urlString, origin: testAddressesData[0], destination: testAddressesData[1], mode: "walking")
    }
    
    func testBicycling() {
        let sut = GoogleDirections(key: GoogleKey, origin: Waypoint(address: testAddressesData[0]), destination: Waypoint(address:testAddressesData[1]), travelMode:Bicycling())
        
        let urlString = sut.urlString
        validateBase(urlString, origin: testAddressesData[0], destination: testAddressesData[1], mode: "bicycling")
    }
    
    func testTransit() {
        let sut = GoogleDirections(key: GoogleKey, origin: Waypoint(address: testAddressesData[0]), destination: Waypoint(address:testAddressesData[1]), travelMode:Transit())
        
        let urlString = sut.urlString
        validateBase(urlString, origin: testAddressesData[0], destination: testAddressesData[1], mode: "transit")
    }
    
    func testLanguage() {
        exerciseParameter("language") { sut, parameter, validate in
            sut.language("ru")
            validate(urlString: sut.urlString, expected: ["ru"], parameter: parameter)
        }
    }

    func testAlteratives() {
        exerciseParameter("alternatives") { sut, parameter, validate in
            sut.provideAlternatives()
            validate(urlString: sut.urlString, expected: ["true"], parameter: parameter)
        }
    }
    
    func testRegion() {
        exerciseParameter("region") { sut, parameter, validate in
            sut.region("gb")
            validate(urlString: sut.urlString, expected: ["gb"], parameter: parameter)
        }
    }
    
    func testUnits() {
        exerciseParameter("units") { sut, parameter, validate in
            sut.units(.Metric)
            validate(urlString: sut.urlString, expected: ["metric"], parameter: parameter)
            sut.units(.Imperial)
            validate(urlString: sut.urlString, expected: ["imperial"], parameter: parameter)
        }
    }
    
    func testOptimizeWaypoints() {

        exerciseParameter("waypoints") { sut, parameter, validate in
            sut.visiting(Waypoint(address: testAddressesData[2]))
            validate(urlString: sut.urlString, expected: [testAddressesData[2]], parameter: parameter)
            sut.optimizeWaypoints()
            validate(urlString: sut.urlString, expected: [testAddressesData[2], "optimize:true"], parameter: parameter)
            sut.visiting(Waypoint(address: testAddressesData[3]))
            validate(urlString: sut.urlString, expected: [testAddressesData[2],testAddressesData[3], "optimize:true"], parameter: parameter)
        }
    }
    
    func testWaypoints() {

        exerciseParameter("waypoints") { sut, parameter, validate in
            sut.visiting(testAddressesData.map { Waypoint(address: $0) })
            validate(urlString: sut.urlString, expected: testAddressesData, parameter: parameter)
        }

        exerciseParameter("waypoints") { sut, parameter, validate in
            sut.visiting(testPlaceIdData.map { Waypoint(placeID: $0) })
            validate(urlString: sut.urlString, expected: testPlaceIdData.map { Waypoint(placeID: $0).urlFragment.stringByRemovingPercentEncoding! }, parameter: parameter)
        }

        exerciseParameter("waypoints") { sut, parameter, validate in
            sut.visiting(testLocationData.map { Waypoint(coordinateLocation: $0) })
            validate(urlString: sut.urlString, expected: testLocationData.map { Waypoint(coordinateLocation: $0).urlFragment.stringByRemovingPercentEncoding! }, parameter: parameter)
        }

    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
