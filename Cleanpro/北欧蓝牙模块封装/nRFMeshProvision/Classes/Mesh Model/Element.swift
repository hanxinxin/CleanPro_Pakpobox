//
//  Element.swift
//  nRFMeshProvision
//
//  Created by Aleksander Nowakowski on 26/03/2019.
//

import Foundation

/// An alias for the Element type.
public typealias MeshElement = Element

public class Element: Codable {
    /// UTF-8 human-readable name of the Element.
    public var name: String?
    /// Numeric order of the Element within this Node.
    public internal(set) var index: UInt8
    /// Description of the Element's location.
    public internal(set) var location: Location
    /// An array of Model objects in the Element.
    public internal(set) var models: [Model]
    
    /// Parent Node. This may be `nil` if the Element was obtained in
    /// Composition Data and has not yet been added to a Node.
    public internal(set) weak var parentNode: Node?
    
    /// This initiator should be used to create Elements that will
    /// be set as local elements using `MeshNetworkManager.localElements`.
    ///
    /// - parameter name:     The optional Element name.
    /// - parameter location: The Element location, by default set to `.unknown`.
    /// - parameter models:   Array of models belonging to this Element.
    ///                       It must contain at least one Model.
    public init(name: String? = nil, location: Location = .unknown, models: [Model]) {
        guard !models.isEmpty else {
            fatalError("An element must contain at least one model.")
        }
        self.name     = name
        self.location = location
        self.models   = models
        // Set temporary index.
        // Final index will be set when Element is added to the Node.
        self.index = 0
        
        models.forEach {
            $0.parentElement = self
        }
    }
    
    internal init(location: Location) {
        self.location = location
        self.models   = []
        
        // Set temporary index.
        // Final index will be set when Element is added to the Node.
        self.index = 0
    }
    
    internal init?(compositionData: Data, offset: inout Int) {
        // Composition Data must have at least 4 bytes: 2 for Location and one for NumS and NumV.
        guard compositionData.count >= offset + 4 else {
            return nil
        }
        // Is Location valid?
        let rawValue: UInt16 = compositionData.read(fromOffset: offset)
        guard let location = Location(rawValue: rawValue) else {
            return nil
        }
        self.location = location
        
        // Read NumS and NumV.
        let sigModelsByteCount    = Int(compositionData[offset + 2]) * 2 // SIG Model ID is 16-bit long.
        let vendorModelsByteCount = Int(compositionData[offset + 3]) * 4 // Vendor Model ID is 32-bit long.
        
        // Ensure the Composition Data have enough data.
        guard compositionData.count >= offset + 3 + sigModelsByteCount + vendorModelsByteCount else {
            return nil
        }
        // 4 bytes have been read.
        offset += 4
        
        // Set temporary index.
        // Final index will be set when Element is added to the Node.
        self.index = 0
        
        // Read models.
        self.models = []
        for o in stride(from: offset, to: offset + sigModelsByteCount, by: 2) {
            let modelId: UInt16 = compositionData.read(fromOffset: o)
            add(model: Model(sigModelId: modelId))
        }
        offset += sigModelsByteCount
        
        for o in stride(from: offset, to: offset + vendorModelsByteCount, by: 4) {
            let companyId: UInt16 = compositionData.read(fromOffset: o)
            let modelId:   UInt16 = compositionData.read(fromOffset: o + 2)
            let vendorModelId = (UInt32(companyId) << 16) | UInt32(modelId)
            add(model: Model(vendorModelId: vendorModelId))
        }
        offset += vendorModelsByteCount
    }
    
    // MARK: - Codable
    
    private enum CodingKeys: CodingKey {
        case name
        case index
        case location
        case models
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name  = try container.decodeIfPresent(String.self, forKey: .name)
        index  = try container.decode(UInt8.self, forKey: .index)
        let locationAsString = try container.decode(String.self, forKey: .location)
        guard let rawValue = UInt16(hex: locationAsString) else {
            throw DecodingError.dataCorruptedError(forKey: .location, in: container,
                                                   debugDescription: "Location must be 4-character hexadecimal string")
        }
        guard let loc = Location(rawValue: rawValue) else {
            throw DecodingError.dataCorruptedError(forKey: .location, in: container,
                                                   debugDescription: "Unknown location: 0x\(locationAsString)")
        }
        location = loc
        models  = try container.decode([Model].self, forKey: .models)
        
        models.forEach {
            $0.parentElement = self
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encode(index, forKey: .index)
        try container.encode(location.hex, forKey: .location)
        try container.encode(models, forKey: .models)
    }
}

// MARK: - Operators

extension Element: Equatable {
    
    public static func == (lhs: Element, rhs: Element) -> Bool {
        return lhs.parentNode === rhs.parentNode && lhs.index == rhs.index
    }
    
    public static func != (lhs: Element, rhs: Element) -> Bool {
        return lhs.parentNode !== rhs.parentNode || lhs.index != rhs.index
    }
    
}


internal extension Element {
    
    /// Adds given model to the Element.
    ///
    /// - parameter model: The model to be added.
    func add(model: Model) {
        models.append(model)
        model.parentElement = self
    }
    
    /// Inserts the given model to the Element at the specified position.
    ///
    /// - parameter model: The model to be added.
    func insert(model: Model, at i: Int) {
        models.insert(model, at: i)
        model.parentElement = self
    }
    
    func addPrimaryElementModels() {
        insert(model: .configurationServer, at: 0)
        insert(model: .configurationClient, at: 1)
        insert(model: .healthServer, at: 2)
        insert(model: .healthClient, at: 3)
    }
    
    /// The primary Element for Provisioner's Node.
    ///
    /// The Element will contain all mandatory Models (Configuration Server
    /// and Health Server) and supported clients (Configuration Client
    /// and Health Client).
    static var primaryElement: Element {
        // The Provisioner will always have a first Element with obligatory
        // Models.
        let element = Element(location: .unknown)
        element.name = "Primary Element"
        // Configuration Server is required for all nodes.
        element.add(model: .configurationServer)
        // Configuration Client is added, as this is a Provisioner's node.
        element.add(model: .configurationClient)
        // Health Server is required for all nodes.
        element.add(model: .healthServer)
        // Health Client is added, as this is a Provisioner's node.
        element.add(model: .healthClient)
        return element
    }
    
}

extension Element: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return "\(name ?? "Element \(index)") (\(unicastAddress.hex))"
    }
    
}
