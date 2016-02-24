//
//  Waypoint.swift
//  SwiftGoogleDirections
//
//  The MIT License (MIT)
//
//  Copyright (c) 2016 Mark Woollard
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import CoreLocation

/**
 *  Structure representing a waypoint, or location on the globe. This can be
 * specified as lat,lng coordinate, an address or a Google place ID.
 */
public struct Waypoint {
    
    /**
     Internal enum to store waypoint
     
     - Coordinate: Coordinate with associated lat,lng
     - PlaceID:    Place ID with associated place ID
     - Address:    Address with associated address
     */
    private enum WaypointType {
        case Coordinate(location:CLLocationCoordinate2D)
        case PlaceID(placeID:String)
        case Address(address:String)
    }
    
    private let waypoint:WaypointType

    /**
     Initialize with an address or placename, such as 'London' or '1 Infinite Loop, Cupertino, California'.
     
     - parameter address: Address of the waypoint
     
     - returns: Initialized waypoint instance
     */
    public init(address:String) {
        self.waypoint = WaypointType.Address(address: address)
    }
    
    /**
     Initialize with a Google place ID such as 'ChIJdd4hrwug2EcRmSrV3Vo6llI'.
     
     - parameter placeID: Place ID of the waypoint
     
     - returns: Initialized waypoint instance
     */
    public init(placeID:String) {
        self.waypoint = WaypointType.PlaceID(placeID: placeID)
    }
    
    /**
     Initialize with lat/lng coordinate pair, provided as CLLocationCoordinate2D
     
     - parameter coordinateLocation: The coordinate of the waypoint
     
     - returns: Initialized waypoint instance
     */
    public init(coordinateLocation:CLLocationCoordinate2D) {
        self.waypoint = WaypointType.Coordinate(location: coordinateLocation)
    }

    /**
     Initialize with lat/lng coordinate pair
     
     - parameter coordinateLocation: The coordinate of the waypoint
     
     - returns: Initialized waypoint instance
     */
    public init(latitude:Double, longitude:Double) {
        self.waypoint = WaypointType.Coordinate(location: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
    }
}

extension Waypoint : URLFragment {
    
    var urlFragment: String {
        switch(self.waypoint) {
        case .Address(let addr):
            return addr.stringByURLEncodingAsQueryParameterValue()
        case .PlaceID(let placeId):
            return "place_id:\(placeId)".stringByURLEncodingAsQueryParameterValue()
        case .Coordinate(let location):
            return String(format: "%.6f,%.6f", location.latitude, location.longitude)
        }
    }
}

extension Waypoint : CustomStringConvertible {
    
    public var description: String {
        return self.urlFragment
    }
    
}

