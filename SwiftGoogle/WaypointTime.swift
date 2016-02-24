//
//  WaypointTime.swift
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

/**
 *  Structure to represent a waypoint time. This is a time of either arrival or departure.
 */
public struct WaypointTime {

    private enum Time {
        case Departure(departure:NSDate)
        case Arrival(arrival:NSDate)
    }

    private var time:Time
    
    /**
     Initialize as arrival time
     
     - parameter arrival: Time of arrival
     
     - returns: Initialized instance representing the arrival time
     */
    init(arrival:NSDate) {
        self.time = Time.Arrival(arrival: arrival)
    }

    /**
     Initialize as arrival time
     
     - parameter departure: Time of departure
     
     - returns: Initialized instance representing the departure time
     */
    init(departure:NSDate) {
        self.time = Time.Departure(departure: departure)
    }
}


extension WaypointTime : URLFragment {
 
    var urlFragment: String {
        switch(self.time) {
        case .Departure(let departure):
            return "departure_time=\(UInt64(departure.timeIntervalSince1970))"
        case .Arrival(let arrival):
            return "arrival_time=\(UInt64(arrival.timeIntervalSince1970))"
        }
    }

}

extension WaypointTime : CustomStringConvertible {
    
    public var description: String {
        return self.urlFragment
    }
    
}

