//
//  SwiftGoogleDirections.swift
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

import Foundation
import CoreLocation
import SwiftyJSON

private let baseURL = "https://maps.googleapis.com/maps/api/directions/json?"

// Class for constructing and issuing request to the Google directions API
// 
// Uses a builder pattern to setup request options, for example:
//
//    GoogleDirections(key, origin:origin, destination:destination)
//      .via(midWaypoint)
//      .units(.Imperial)
//      .language("ru")
//      .directions() { data, req, error in
//          // Process response results...
//      }
//
public class GoogleDirections {

    /**
     *  Private struct for storing a waypoint and whether its a try waypoint or
     * just a point to traval via.
     */
    private struct _Waypoint : URLFragment {
        let waypoint:Waypoint
        let via:Bool
        
        init(waypoint:Waypoint, via:Bool = false) {
            self.waypoint = waypoint
            self.via = via
        }
        
        var urlFragment:String {
            get {
                if via {
                    return "via:\(waypoint)".stringByURLEncodingAsQueryParameterValue()
                }
                return waypoint.description
            }
        }
    }
    
    /// ivars to hold the state of the pending request
    private let _key:String
    private let _origin:Waypoint
    private let _destination:Waypoint
    private let _travelMode:TravelMode
    private var _waypoints = [_Waypoint]()
    private var _units:Units?
    private var _alternatives = false
    private var _region:String?
    private var _language:String?
    private var _optimize:Bool = false
    
    /**
     Initialize with the minimum required information for a request. That is a valid Google API key,
     origin, destination and travel mode. Driving is the default.
     
     - parameter key:         Google API key
     - parameter origin:      Waypoint defining origin of route request
     - parameter destination: Waypoint defining destiation of route request
     - parameter travelMode:  Mode of travel, defaults to Driving
     
     - returns: Initialized GoogleDirection instance
     */
    public init(key:String, origin:Waypoint, destination:Waypoint, travelMode:TravelMode = Driving()) {
        self._origin = origin
        self._destination = destination
        self._key = key
        self._travelMode = travelMode
    }
    
    /**
     By default only one route provided, set provideAlternatives to get multiple suggestions if available.
     
     - returns: Self
     */
    public func provideAlternatives() -> Self {
        self._alternatives = true
        return self
    }
    
    /**
     Adds a waypoint to the route as a point to visit
     
     - parameter waypoint: Waypoint to visit
     
     - returns: Self
     */
    public func visiting(waypoint:Waypoint) -> Self {
        self._waypoints.append(_Waypoint(waypoint: waypoint))
        return self
    }
    
    /**
     Adds visit waypoints from sequence of Waypoint
     
     - parameter waypoints: Sequence of waypoints
     
     - returns: Self
     */
    public func visiting<S:SequenceType where S.Generator.Element ==  Waypoint>(waypoints:S) -> Self {
        self._waypoints.appendContentsOf(waypoints.map { _Waypoint(waypoint:$0) })
        return self
    }
    
    /**
     Adds a waypoint to the route as a point to traval via
     
     - parameter waypoint: Waypoint to visit
     
     - returns: Self
     */
    public func via(waypoint:Waypoint) -> Self {
        self._waypoints.append(_Waypoint(waypoint: waypoint, via: true))
        return self
    }
    
    /**
     Adds a via waypoints from sequence of Waypoint
     
     - parameter waypoints: Sequence of waypoints
     .
     - returns: Self
     */
    public func via<S:SequenceType where S.Generator.Element ==  Waypoint>(waypoints:S ) -> Self {
        self._waypoints.appendContentsOf(waypoints.map { _Waypoint(waypoint:$0, via: true) })
        return self
    }
    
    public func optimizeWaypoints() -> Self {
        self._optimize = true
        return self
    }
    
    public func units(units:Units) -> Self {
        self._units = units
        return self
    }
    
    public func region(region:String) -> Self {
        self._region = region
        return self
    }
    
    public func language(lang:String) -> Self {
        self._language = lang
        return self
    }
}

let optimize = "optimize:true".stringByURLEncodingAsQueryParameterValue()

extension GoogleDirections {

    
    // Get url string for request
    public var urlString:String {
        get {
            var urlString = baseURL
            urlString.appendContentsOf("key=\(self._key)")
            urlString.appendContentsOf("&origin=\(self._origin.urlFragment)")
            urlString.appendContentsOf("&destination=\(self._destination.urlFragment)")
            urlString.appendContentsOf("&travel_mode=\(self._travelMode.urlFragment)")
            if self._waypoints.count > 0 {
                var list = self._optimize ? "&waypoints=\(optimize)|" : "&waypoints="
                list.appendContentsOf(self._waypoints.map { $0.urlFragment }.joinWithSeparator("|"))
                urlString.appendContentsOf(list)
            }
            if let units = self._units {
                urlString.appendContentsOf("&units=\(units.urlFragment)")
            }
            if _alternatives {
                urlString.appendContentsOf("&alternatives=true")
            }
            if let bias = self._region {
                urlString.appendContentsOf("&region=\(bias.stringByURLEncodingAsQueryParameterValue())")
            }
            if let lang = self._language {
                urlString.appendContentsOf("&language=\(lang.stringByURLEncodingAsQueryParameterValue())")
            }
            
            return urlString
        }
    }

    // Get NSURL for request
    public var url:NSURL {
        get {
            return NSURL(string: self.urlString)!
        }
    }
    
    // Get NSURLRequest for request
    public var urlRequest:NSURLRequest {
        get {
            return NSURLRequest(URL: self.url)
        }
    }
    
    /**
     Issue async request for route search
     
     - parameter completion: Completion to be called when async operation completes
     
     - returns: NSURLSessionTask for ongoing request
     */
    public func directions(completion:(json:JSON?, error:ErrorType?) -> Void) -> NSURLSessionTask {
        let task = NSURLSession.sharedSession().dataTaskWithRequest(self.urlRequest) { data, response, err in
            
            if let err = err {
                completion(json: nil, error:err)
                return
            }

            guard let data = data else {
                completion(json: nil, error:err)
                return
            }

            let json = JSON(data: data)
            if let error = json.error {
                completion(json: nil, error: error)
                return
            }
            
            completion(json: json, error: nil)
        }
        
        task.resume()
        return task
    }
}

extension GoogleDirections : CustomStringConvertible {
    
    public var description:String {
        get {
            return self.urlString
        }
    }
}
