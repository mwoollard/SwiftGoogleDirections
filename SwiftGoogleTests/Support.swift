//
//  Support.swift
//  SwiftGoogleDirections
//
//  Created by Mark Woollard on 24/02/2016.
//  Copyright © 2016 Mark Woollard. All rights reserved.
//

import XCTest

@testable import SwiftGoogleDirections

func +(lhs: [String:Set<String>], rhs: (String,Set<String>)) -> [String:Set<String>] {
    var ret = [String:Set<String>]()
    lhs.forEach { ret[$0.0] = $0.1 }
    ret[rhs.0] = (ret[rhs.0] ?? Set<String>()).union(rhs.1)
    return ret
}

extension String {
    
    var url:String {
        return self.componentsSeparatedByString("?").first!
    }
    
    var parameters:[String:Set<String>] {
        return self.componentsSeparatedByString("?").last!
            .componentsSeparatedByString("&")
            .map { $0.componentsSeparatedByString("=") }
            .map { ($0.first!, Set<String>(
                $0.last!
                .componentsSeparatedByString("|")
                .map { $0.stringByRemovingPercentEncoding! }
                    )
                )
            }
            .reduce([String:Set<String>]()) { $0 + $1 }
    }
}

extension XCTestCase {
    
    func validateBase(urlString:String, origin:String, destination:String, mode:String) {
        XCTAssertEqual(BaseURL, urlString.url)
        XCTAssertEqual(Set<String>([GoogleKey]), urlString.parameters["key"])
        XCTAssertEqual(Set<String>([origin]), urlString.parameters["origin"])
        XCTAssertEqual(Set<String>([destination]), urlString.parameters["destination"])
        XCTAssertEqual(Set<String>([mode]), urlString.parameters["travel_mode"])
    }
    
    func exerciseParameter(parameter:String, operation:(sut:GoogleDirections, parameter:String, validate:(urlString:String, expected:[String], parameter:String) -> Void) -> Void) {
        let sut = GoogleDirections(key: GoogleKey, origin: Waypoint(address: testAddressesData[0]), destination: Waypoint(address:testAddressesData[1]))
        
        // Should not produce parameter
        var urlString = sut.urlString
        validateBase(urlString, origin: testAddressesData[0], destination: testAddressesData[1], mode: "driving")
        XCTAssertEqual(nil, sut.urlString.parameters[parameter])
        
        operation(sut: sut, parameter: parameter) { s, e, p in
            self.validateBase(urlString, origin: testAddressesData[0], destination: testAddressesData[1], mode: "driving")
            XCTAssertEqual(Set<String>(e), sut.urlString.parameters[p])
        }
        
        // Should now have language parameter
        urlString = sut.urlString
        validateBase(urlString, origin: testAddressesData[0], destination: testAddressesData[1], mode: "driving")
    }
    
}