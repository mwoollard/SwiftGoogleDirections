//
//  TravelMode.swift
//  SwiftGoogle
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

import Foundation

// Base class for all travel modes, but cannot be instantiated outside of framework directly
public class TravelMode {

    /**
     Internal enum for storing associated data with
     */
    internal enum TravelModeInfo {
        /**
         Enum value for driving request with options related to driving
         
         - parameter departureTime: Optional departure time
         - parameter avoidTolls:    Whether or not to avoid tolls
         - parameter avoidHighways: Whether or not to avoid highways
         - parameter avoidFerries:  Whether or not to avoid ferries
         - parameter trafficModel:  Optional traffic model to use
         */
        case Driving(departureTime:NSDate?, avoidTolls:Bool, avoidHighways:Bool, avoidFerries:Bool, trafficModel:TrafficModel?)
        
        /**
         Enum value for driving request with options related to walking
         
         - parameter avoidIndoor: Whether or not to avoid indoor routes
         */
        case Walking(avoidIndoor:Bool)
        
        /**
         Enum value for bicycling request
         */
        case Bicycling
        
        /**
         Enum value for driving request with options related to transit routing
         
         - parameter time:                     Waypoint time specifying either departure or arrival tim
         - parameter transitMode:              Optional list of transit modes to use when building route
         - parameter transitRoutingPreference: Optional transit routing preferences
         */
        case Transit(time:WaypointTime?, transitMode:[TransitMode]?, transitRoutingPreference:TransitRoutingPreference?)
    }

    internal let travelMode:TravelModeInfo
    
    /**
     Initialize with above enum structure
     
     - parameter travelMode: The travel mode
     
     - returns: Initialized instance
     */
    internal init(travelMode:TravelModeInfo) {
        self.travelMode = travelMode
    }
}

/// Public subclass to represent / construct driving routing request
public class Driving : TravelMode {

    /**
     Initialize Driving request object
     
     - parameter departureTime: Optional departure time
     - parameter avoidTolls:    Whether or not to avoid tolls, defaults no
     - parameter avoidHighways: Whether or not to avoid highways, defaults to no
     - parameter avoidFerries:  Whether or not to avoid ferries, defaults to no
     - parameter trafficModel:  Optional traffic model to use
     
     - returns: Initialized instance of Driving request
     */
    public init(departureTime:NSDate? = nil, avoidTolls:Bool = false, avoidHighways:Bool = false, avoidFerries:Bool = false, trafficModel:TrafficModel? = nil) {
        super.init(travelMode: TravelModeInfo.Driving(departureTime: departureTime, avoidTolls: avoidTolls, avoidHighways: avoidHighways, avoidFerries: avoidFerries, trafficModel: trafficModel))
    }

}

/// Public subclass to represent bicycling routing request
public class Bicycling : TravelMode {
    
    /**
     Initialize Bicycling request object
     
     - returns: Initialized instance of Bicycling request
     */
    public init() {
        super.init(travelMode: TravelModeInfo.Bicycling)
    }
}

/// Public subclass to represent walking routing request
public class Walking : TravelMode {

    /**
     Initialize Walking request object
     
     - parameter avoidIndoor: Whether or not to avoid routes that have indoor steps, default no
     
     - returns: Initialized instance of Walking request
     */
    public init(avoidIndoor:Bool = false) {
        super.init(travelMode: TravelModeInfo.Walking(avoidIndoor: avoidIndoor))
    }
}

/// Public subclass to represent transit routing request
public class Transit : TravelMode {

    /**
     Initialize Transit request object
     
     - parameter time:                     Waypoint time for either arrival or departure time
     - parameter transitMode:              Optional list of transit modes to use when building route
     - parameter transitRoutingPreference: Optional transit routing preferences
     
     - returns: Initialized instance of Transit request
     */
    public init(time:WaypointTime? = nil, transitMode:[TransitMode]? = nil, transitRoutingPreference:TransitRoutingPreference? = nil) {
        super.init(travelMode: TravelModeInfo.Transit(time: time, transitMode: transitMode, transitRoutingPreference: transitRoutingPreference))
    }
}

extension TravelMode : URLFragment {
    var urlFragment: String {
        switch(self.travelMode) {
        case .Driving(let departure, let avoidTolls, let avoidHighways, let avoidFerries, let trafficModel):
            let time = departure != nil ? "&departure_time=\(UInt64(departure!.timeIntervalSince1970))" : ""
            var avoids = [String]()
            if avoidTolls { avoids.append("tolls") }
            if avoidHighways { avoids.append("highways") }
            if avoidFerries { avoids.append("ferries") }
            let avoid = avoids.count > 0 ? "&avoid=\(avoids.joinWithSeparator("|"))" : ""
            let model = trafficModel != nil ? "&traffic_model=\(trafficModel!.urlFragment)" : ""
            return "driving\(time)\(avoid)\(model)"
        case .Walking(let avoidIndoor):
            let avoid = avoidIndoor ? "&avoid=indoor" : ""
            return "walking\(avoid)"
        case .Bicycling:
            return "bicycling"
        case .Transit(let waypointTime, let transitMode, let transitRoutingPref):
            let time = waypointTime != nil ? "&\(waypointTime!.urlFragment)" : ""
            let mode = transitMode?.count > 0 ? "&transit_mode=\(Set<String>(transitMode!.map { $0.urlFragment }).joinWithSeparator("|").stringByURLEncodingAsQueryParameterValue())" : ""
            let routing = transitRoutingPref != nil ? "&transit_routing_preference=\(transitRoutingPref!.urlFragment)" : ""
            return "transit\(time)\(mode)\(routing)"
        }
    }
}

extension TravelMode : CustomStringConvertible {
    public var description:String {
        return self.urlFragment
    }
}

