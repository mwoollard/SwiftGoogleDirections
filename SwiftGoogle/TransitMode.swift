//
//  TransitMode.swift
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
 Enum defining valid transit modes
 
 - Bus:    Bus
 - Subway: Subway
 - Train:  Train
 - Tram:   Tram
 - Rail:   All types of rail transport, equivalent of Subway|Tram|Rail
 */
public enum TransitMode {
    case Bus
    case Subway
    case Train
    case Tram
    case Rail
}

extension TransitMode : URLFragment {
    var urlFragment: String {
        switch(self) {
        case .Bus:
            return "bus"
        case .Subway:
            return "subway"
        case .Train:
            return "train"
        case .Tram:
            return "tram"
        case .Rail:
            return "rail"
        }
    }
}

extension TransitMode : CustomStringConvertible {
    public var description: String {
        return self.urlFragment
    }
}
