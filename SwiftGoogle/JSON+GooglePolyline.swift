//
//  JSON+GooglePolyline.swift
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

import SwiftyJSON
import MapKit
import SwiftGooglePolyline

// MARK: - SwiftyJSON extension to support Google Polylines
extension JSON {
    
    // Get decoded polyline string as coordinate array if valid polyline string, or nil
    var polyline:[CLLocationCoordinate2D]? {
        get {
            do {
               return try self.string!.makeCoordinateArrayFromGooglePolyline()
            } catch {
                return nil
            }
        }
    }
    
    // Get decoded polyline string as coordinate array, throws exception if string invalid or not a polyline
    var polylineValue:[CLLocationCoordinate2D] {
        get {
            return try! self.stringValue.makeCoordinateArrayFromGooglePolyline()
        }
    }
    
    // Get decoded polyline string as MKPolyline if valid polyline string, or nil
    var mkPolyline:MKPolyline? {
        get {
            guard let polyline = self.string else {
                return nil
            }
            
            return try! polyline.makeMKPolylineFromGooglePolyline()
        }
    }
    
    // Get decoded polyline string as MKPolyline, throws exception if string invalid or not a polyline
    var mkPolylineValue : MKPolyline {
        get {
            return try! self.stringValue.makeMKPolylineFromGooglePolyline()
        }
    }
}