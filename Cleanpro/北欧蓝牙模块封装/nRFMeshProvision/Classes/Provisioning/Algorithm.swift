//
//  Algorithm.swift
//  nRFMeshProvision
//
//  Created by Aleksander Nowakowski on 07/05/2019.
//

import Foundation

/// The algorighm used for calculating Device Key.
public enum Algorithm {
    /// FIPS P-256 Elliptic Curve algorithm will be used to calculate the
    /// shared secret.
    case fipsP256EllipticCurve
    
    var value: Data {
        switch self {
        case .fipsP256EllipticCurve: return Data([0])
        }
    }
}

extension Algorithm: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        switch self {
        case .fipsP256EllipticCurve:
            return "FIPS P-256 Elliptic Curve"
        }
    }
    
}

/// A set of algorighms supported by the Unprovisioned Device.
public struct Algorithms: OptionSet {
    public let rawValue: UInt16
    
    /// FIPS P-256 Elliptic Curve algorithm is supported.
    public static let fipsP256EllipticCurve = Algorithms(rawValue: 1 << 0)
    
    public init(rawValue: UInt16) {
        self.rawValue = rawValue
    }
    
}

extension Algorithms: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        if rawValue == 0 {
            return "None"
        }
        return [(.fipsP256EllipticCurve, "FIPS P-256 Elliptic Curve")]
            .compactMap { (option, name) in contains(option) ? name : nil }
            .joined(separator: ", ")
    }
    
}
