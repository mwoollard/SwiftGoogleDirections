//
//  TravelModeTests.swift
//  SwiftGoogle
//
//  Created by Mark Woollard on 22/02/2016.
//  Copyright © 2016 Mark Woollard. All rights reserved.
//

import XCTest

@testable import SwiftGoogleDirections

class TravelModeTests: XCTestCase {

    func testWalking() {
        
        XCTAssertEqual("walking", Walking().urlFragment)
        XCTAssertEqual("walking", Walking(avoidIndoor: false).urlFragment)
        XCTAssertEqual("walking&avoid=indoor", Walking(avoidIndoor: true).urlFragment)
    }

    func testBicycling() {
        XCTAssertEqual("bicycling", Bicycling().urlFragment)
    }
    
    func testTransit() {
        XCTAssertEqual("transit", Transit().urlFragment)
    }
    
    func parseParameters(urlString:String) {
    
        urlString.componentsSeparatedByString("?").last
    }
    
    func parseParamValues(urlString:String, param:String) -> Set<String> {
        return Set<String>(
            urlString.componentsSeparatedByString("&")
                .filter { $0.hasPrefix("\(param)=") }
                .map { $0.substringFromIndex($0.startIndex.advancedBy(param.characters.count+1)) }
                .flatMap { $0.componentsSeparatedByString("|") }
        )
    }
    
    func testDriving() {
        XCTAssertEqual("driving", Driving().urlFragment)
        let now = NSDate()
        
        XCTAssertEqual("driving&departure_time=\(UInt64(now.timeIntervalSince1970))", Driving(departureTime: now).urlFragment)
        
        [false,true].forEach { tolls in
            [false,true].forEach { highways in
                [false,true].forEach { ferries in
                    
                    let result = parseParamValues(Driving(avoidTolls:tolls, avoidHighways:highways, avoidFerries:ferries).urlFragment, param: "avoid")
                    var expected = Set<String>()
                    if tolls { expected.insert("tolls") }
                    if highways { expected.insert("highways") }
                    if ferries { expected.insert("ferries") }
                    XCTAssertEqual(expected, result)
                }
            }
        }
        
        XCTAssertEqual("driving&traffic_model=best_guess", Driving(trafficModel: TrafficModel.BestGuess).urlFragment)
        XCTAssertEqual("driving&traffic_model=optimistic", Driving(trafficModel: TrafficModel.Optimistic).urlFragment)
        XCTAssertEqual("driving&traffic_model=pessimistic", Driving(trafficModel: TrafficModel.Pessimistic).urlFragment)

        (0..<100).forEach { _ in
            let avoidTolls = arc4random_uniform(2) == 1 ? true : false
            let avoidHighways = arc4random_uniform(2) == 1 ? true : false
            let avoidFerries = arc4random_uniform(2) == 1 ? true : false

            var trafficModel:TrafficModel?
            var trafficModelStr:String?
            switch(arc4random_uniform(4)) {
            case 0:
                trafficModel = TrafficModel.BestGuess
                trafficModelStr = "best_guess"
                break
            case 1:
                trafficModel = TrafficModel.Optimistic
                trafficModelStr = "optimistic"
                break
            case 2:
                trafficModel = TrafficModel.Pessimistic
                trafficModelStr = "pessimistic"
                break
            default:
                trafficModel = nil
                trafficModelStr = nil
            }
            
            let fragment = Driving(departureTime: now, avoidTolls: avoidTolls, avoidHighways: avoidHighways, avoidFerries: avoidFerries, trafficModel: trafficModel).urlFragment
            
            let departure = parseParamValues(fragment, param: "departure_time")
            let avoid = parseParamValues(fragment, param: "avoid")
            let model = parseParamValues(fragment, param: "traffic_model")
 
            XCTAssertTrue(model.count < 2)
            XCTAssertEqual(trafficModelStr, model.first)
            
            XCTAssertEqual(UInt32(now.timeIntervalSince1970), UInt32(departure.first!))
            
            var expected = Set<String>()
            if avoidTolls { expected.insert("tolls") }
            if avoidHighways { expected.insert("highways") }
            if avoidFerries { expected.insert("ferries") }
            XCTAssertEqual(expected, avoid)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
