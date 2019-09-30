//
//  MeshNetworkManager.swift
//  nRFMeshProvision
//
//  Created by Aleksander Nowakowski on 19/03/2019.
//

import Foundation

public class MeshNetworkManager {
    /// Mesh Network data.
    private var meshData: MeshData
    /// The Network Layer handler.
    private var networkManager: NetworkManager?
    /// Storage to keep the app data.
    private let storage: Storage
    /// A queue to handle incoming and outgoing messages.
    internal let queue: DispatchQueue
    /// A queue to call delegate methods on.
    internal let delegateQueue: DispatchQueue
    
    /// The Proxy Filter state.
    public internal(set) var proxyFilter: ProxyFilter?
    
    /// The logger delegate will be called whenever a new log entry is created.
    public weak var logger: LoggerDelegate?
    /// The delegate will receive callbacks whenever a complete
    /// Mesh Message has been received and reassembled.
    public weak var delegate: MeshNetworkDelegate?
    /// The sender object should send PDUs created by the manager
    /// using any Bearer.
    public weak var transmitter: Transmitter?
    
    // MARK: - Vendor message properties
    
    /// Registered vendor message types.
    internal var vendorTypes: [UInt32 : VendorMessage.Type] = [:]
    
    // MARK: - Network Manager properties
    
    /// The Default TTL will be used for sending messages, if the value has
    /// not been set in the Provisioner's Node. By default it is set to 5,
    /// which is a reasonable value. The TTL shall be in range 2...127.
    public var defaultTtl: UInt8 = 5
    /// The timeout after which an incomplete segmented message will be
    /// abandoned. The timer is restarted each time a segment of this
    /// message is received.
    ///
    /// The incomplete timeout should be set to at least 10 seconds.
    public var incompleteMessageTimeout: TimeInterval = 10.0
    /// The amount of time after which the lower transport layer sends a
    /// Segment Acknowledgment message after receiving a segment of a
    /// multi-segment message where the destination is a Unicast Address
    /// of the Provisioner's Element.
    ///
    /// The acknowledgment timer shall be set to a minimum of
    /// 150 + 50 * TTL milliseconds. The TTL dependent part is added
    /// automatically, and this value shall specify only the constant part.
    public var acknowledgmentTimerInterval: TimeInterval = 0.150
    /// The time within which a Segment Acknowledgment message is
    /// expected to be received after a segment of a segmented message has
    /// been sent. When the timer is fired, the non-acknowledged segments
    /// are repeated, at most `retransmissionLimit` times.
    ///
    /// The transmission timer shall be set to a minimum of
    /// 200 + 50 * TTL milliseconds. The TTL dependent part is added
    /// automatically, and this value shall specify only the constant part.
    ///
    /// If the bearer is using GATT, it is recommended to set the transmission
    /// interval longer than the connection interval, so that the acknowledgment
    /// had a chance to be received.
    public var transmissionTimerInteral: TimeInterval = 0.200
    /// Number of times a non-acknowledged segment of a segmented message
    /// will be retransmitted before the message will be cancelled.
    ///
    /// The limit may be decreased with increasing of `transmissionTimerInterval`
    /// as the target Node has more time to reply with the Segment
    /// Acknowledgment message.
    public var retransmissionLimit: Int = 10
    /// If the Element does not receive a response within a period of time known
    /// as the acknowledged message timeout, then the Element may consider the
    /// message has not been delivered, without sending any additional messages.
    ///
    /// The `meshNetworkManager(_:failedToSendMessage:from:to:error)`
    /// callback will be called on timeout.
    ///
    /// The acknowledged message timeout should be set to a minimum of 30 seconds.
    public var acknowledgmentMessageTimeout: TimeInterval = 30.0
    /// The base time after which the acknowledgmed message will be repeated.
    ///
    /// The repeat timer will be set to the base time + 50 * TTL milliseconds +
    /// 50 * segment count. The TTL and segment count dependent parts are added
    /// automatically, and this value shall specify only the constant part.
    public var acknowledgmentMessageInterval: TimeInterval = 2.0
    
    // MARK: - Computed properties
    
    /// Returns the MeshNetwork object.
    public var meshNetwork: MeshNetwork? {
        return meshData.meshNetwork
    }
    
    /// Returns `true` if Mesh Network has been created, `false` otherwise.
    public var isNetworkCreated: Bool {
        return meshData.meshNetwork != nil
    }
    
    // MARK: - Constructors
    
    /// Initializes the MeshNetworkManager.
    ///
    /// If storage is not provided, a local file will be used instead.
    ///
    /// - parameter storage: The storage to use to save the network configuration.
    /// - parameter queue: The DispatQueue to process reqeusts on. By default
    ///                    the a serial background queue will be used.
    ///                    It is important this queue to be serial, otherwise packets
    ///                    may be handled in random order and discarded, when one
    ///                    with higher SEQ has been already processed.
    /// - parameter delegateQueue: The DispatQueue to call delegate methods on.
    ///                            By default the global main queue will be used.
    /// - seeAlso: `LocalStorage`
    public init(using storage: Storage = LocalStorage(),
                queue: DispatchQueue = DispatchQueue(label: "Message handler", qos: .background),
                delegateQueue: DispatchQueue = DispatchQueue.main) {
        self.storage = storage
        self.meshData = MeshData()
        self.queue = queue
        self.delegateQueue = delegateQueue
    }
    
    /// Initializes the MeshNetworkManager. It will use the `LocalStorage`
    /// with the given file name.
    ///
    /// - parameter fileName: File name to keep the configuration.
    /// - seeAlso: `LocalStorage`
    public convenience init(using fileName: String) {
        self.init(using: LocalStorage(fileName: fileName))
    }
    
}

// MARK: - Mesh Network API

public extension MeshNetworkManager {
    
    /// Generates a new Mesh Network configuration with default values.
    /// This method will override the existing configuration, if such exists.
    /// The mesh network will contain one Provisioner with given name.
    ///
    /// Network Keys and Application Keys must be added manually
    /// using `add(networkKey:name)` and `add(applicationKey:name)`.
    ///
    /// - parameter name:            The user given network name.
    /// - parameter provisionerName: The user given local provisioner name.
    func createNewMeshNetwork(withName name: String, by provisionerName: String) -> MeshNetwork {
        return createNewMeshNetwork(withName: name, by: Provisioner(name: provisionerName))
    }
    
    /// Generates a new Mesh Network configuration with default values.
    /// This method will override the existing configuration, if such exists.
    /// The mesh network will contain one Provisioner with given name.
    ///
    /// Network Keys and Application Keys must be added manually
    /// using `add(networkKey:name)` and `add(applicationKey:name)`.
    ///
    /// - parameter name:      The user given network name.
    /// - parameter provisioner: The default Provisioner.
    func createNewMeshNetwork(withName name: String, by provisioner: Provisioner) -> MeshNetwork {
        let network = MeshNetwork(name: name)
        
        // Add a new default provisioner.
        try! network.add(provisioner: provisioner)
        
        meshData.meshNetwork = network
        networkManager = NetworkManager(self)
        proxyFilter = ProxyFilter(self)
        return network
    }
    
    /// An array of Elements of the local Node.
    ///
    /// Use this property if you want to extend the capabilities of the local
    /// Node with additional Elements and Models. For example, you may add an
    /// additional Element with Generic On/Off Client Model if you support this
    /// feature in your app. Make sure there is enough addresses for all the
    /// Elements created. If a collision is found, the coliding Elements will
    /// be ignored.
    ///
    /// The Element with all mandatory Models (Configuration Server and Client
    /// and Health Server and Client) will be added automatically at index 0,
    /// and should be skipped when setting.
    ///
    /// The mesh network must be created or loaded before setting this field,
    /// otherwise it has no effect.
    var localElements: [Element] {
        get {
            return meshNetwork?.localElements ?? []
        }
        set {
            meshNetwork?.localElements = newValue
        }
    }
    
    /// Registers the given Vendor Message type in the manager. Whenever
    /// a mesh message with its opcode is received, the manager will instantiate
    /// an object of this type and return using the `delegate`.
    ///
    /// - parameter vendorMessageType: The Vendor Message type to register.
    /// - throws: This method throws when the registered message has an invalid
    ///           op code, that is not matching vendor op code requirement.
    func register(vendorMessageType: StaticVendorMessage.Type) throws {
        let opCode = vendorMessageType.opCode
        guard (opCode & 0xFFC00000) == 0x00C00000 else {
            throw MeshMessageError.invalidOpCode
        }
        vendorTypes[opCode] = vendorMessageType
    }
    
    /// Registers the given Vendor Message type in the manager. Whenever
    /// a mesh message with its opcode is received, the manager will instantiate
    /// an object of this type and return using the `delegate`.
    ///
    /// This method should be used when the Op Code is not known during
    /// compliation. Otherwise, the `register(vendorMessageType:)` should
    /// be preferred.
    ///
    /// - parameter vendorMessageType: The Vendor Message type to register.
    /// - parameter opCode: The runtime given op code of the message.
    /// - throws: This method throws when the given op code is not matching
    ///           vendor op code requirement.
    func register(vendorMessageType: VendorMessage.Type, withOpCode opCode: UInt32) throws {
        let opCode = opCode
        guard (opCode & 0xFFC00000) == 0x00C00000 else {
            throw MeshMessageError.invalidOpCode
        }
        vendorTypes[opCode] = vendorMessageType
    }
}

// MARK: - Send / Receive Mesh Messages

public extension MeshNetworkManager {
    
    /// This method should be called whenever a PDU has been received
    /// from the mesh network using any bearer.
    /// When a complete Mesh Message is received and reassembled, the
    /// delegate's `meshNetwork(:didDeliverMessage:from)` will be called.
    ///
    /// For easier integration with Bearers use
    /// `bearer(didDeliverData:ofType)` instead, and set the manager
    /// as Bearer's `dataDelegate`.
    ///
    /// - parameter data: The PDU received.
    /// - parameter type: The PDU type.
    func bearerDidDeliverData(_ data: Data, ofType type: PduType) {
        guard let networkManager = networkManager else {
            return
        }
        queue.async {
            networkManager.handle(incomingPdu: data, ofType: type)
        }
    }
    
    /// Encrypts the message with the Application Key and a Network Key
    /// bound to it, and sends to the given destination address.
    ///
    /// This method does not send nor return PDUs to be sent. Instead,
    /// for each created segment it calls transmitter's `send(:ofType)`,
    /// which should send the PDU over the air. This is in order to support
    /// retransmittion in case a packet was lost and needs to be sent again
    /// after block acknowlegment was received.
    ///
    /// A `delegate` method will be called when the message has been sent,
    /// delivered, or failed to be sent.
    ///
    /// - parameter message:        The message to be sent.
    /// - parameter localElement:   The source Element. If `nil`, the primary
    ///                             Element will be used. The Element must belong
    ///                             to the local Provisioner's Node.
    /// - parameter destination:    The destination address.
    /// - parameter applicationKey: The Application Key to sign the message.
    /// - throws: This method throws when the mesh network has not been created,
    ///           the local Node does not have configuration capabilities
    ///           (no Unicast Address assigned), or the given local Element
    ///           does not belong to the local Node.
    func send(_ message: MeshMessage,
              from localElement: Element? = nil, to destination: MeshAddress,
              using applicationKey: ApplicationKey) throws {
        guard let networkManager = networkManager, let meshNetwork = meshNetwork else {
            print("Error: Mesh Network not created")
            throw MeshNetworkError.noNetwork
        }
        guard let localNode = meshNetwork.localProvisioner?.node,
              let source = localElement ?? localNode.elements.first else {
            print("Error: Local Provisioner has no Unicast Address assigned")
            throw AccessError.invalidSource
        }
        guard source.parentNode == localNode else {
            print("Error: The Element does not belong to the local Node")
            throw AccessError.invalidElement
        }
        queue.async {
            networkManager.send(message, from: source, to: destination, using: applicationKey)
        }
    }
    
    /// Encrypts the message with the Application Key and a Network Key
    /// bound to it, and sends to the given Group.
    ///
    /// A `delegate` method will be called when the message has been sent,
    /// or failed to be sent.
    ///
    /// - parameter message:        The message to be sent.
    /// - parameter localElement:   The source Element. If `nil`, the primary
    ///                             Element will be used. The Element must belong
    ///                             to the local Provisioner's Node.
    /// - parameter group:          The target Group.
    /// - parameter applicationKey: The Application Key to sign the message.
    /// - throws: This method throws when the mesh network has not been created,
    ///           the local Node does not have configuration capabilities
    ///           (no Unicast Address assigned), or the given local Element
    ///           does not belong to the local Node.
    func send(_ message: MeshMessage,
              from localElement: Element? = nil, to group: Group,
              using applicationKey: ApplicationKey) throws {
        try send(message, from: localElement, to: group.address, using: applicationKey)
    }
    
    /// Encrypts the message with the first Application Key bound to the given
    /// Model and a Network Key bound to it, and sends it to the Node
    /// to which the Model belongs to.
    ///
    /// A `delegate` method will be called when the message has been sent,
    /// delivered, or fail to be sent.
    ///
    /// - parameter message:       The message to be sent.
    /// - parameter localElement:  The source Element. If `nil`, the primary
    ///                            Element will be used. The Element must belong
    ///                            to the local Provisioner's Node.
    /// - parameter model:         The destination Model.
    /// - parameter applicationKey: The Application Key to sign the message.
    /// - throws: This method throws when the mesh network has not been created,
    ///           the target Model does not belong to any Element, or has
    ///           no Application Key bound to it, or when
    ///           the local Node does not have configuration capabilities
    ///           (no Unicast Address assigned), or the given local Element
    ///           does not belong to the local Node.
    func send(_ message: MeshMessage,
              from localElement: Element? = nil, to model: Model) throws {
        guard let element = model.parentElement else {
            print("Error: Element does not belong to a Node")
            throw AccessError.invalidDestination
        }
        guard let firstKeyIndex = model.bind.first,
              let meshNetwork = meshNetwork,
              let applicationKey = meshNetwork.applicationKeys[firstKeyIndex] else {
            print("Error: Model is not bound to any Application Key")
            throw AccessError.modelNotBoundToAppKey
        }
        try send(message, from: localElement, to: MeshAddress(element.unicastAddress),
                 using: applicationKey)
    }
    
    /// Encrypts the message with the common Application Key bound to both given
    /// Models and a Network Key bound to it, and sends it to the Node
    /// to which the target Model belongs to.
    ///
    /// A `delegate` method will be called when the message has been sent,
    /// delivered, or fail to be sent.
    ///
    /// - parameter message:       The message to be sent.
    /// - parameter localElement:  The source Element. If `nil`, the primary
    ///                            Element will be used. The Element must belong
    ///                            to the local Provisioner's Node.
    /// - parameter model:         The destination Model.
    /// - throws: This method throws when the mesh network has not been created,
    ///           the local or target Model do not belong to any Element, or have
    ///           no common Application Key bound to them, or when
    ///           the local Node does not have configuration capabilities
    ///           (no Unicast Address assigned), or the given local Element
    ///           does not belong to the local Node.
    func send(_ message: MeshMessage,
              from localModel: Model, to model: Model) throws {
        guard let meshNetwork = meshNetwork else {
            print("Error: Mesh Network not created")
            throw MeshNetworkError.noNetwork
        }
        guard let element = model.parentElement else {
            print("Error: Element does not belong to a Node")
            throw AccessError.invalidDestination
        }
        guard let localElement = localModel.parentElement else {
            print("Error: Source Model does not belong to an Element")
            throw AccessError.invalidSource
        }
        guard let commonKeyIndex = model.bind.first(where: { localModel.bind.contains($0) }),
              let applicationKey = meshNetwork.applicationKeys[commonKeyIndex] else {
            print("Error: Models are not bound to any common Application Key")
            throw AccessError.modelNotBoundToAppKey
        }
        try send(message, from: localElement, to: MeshAddress(element.unicastAddress), using: applicationKey)
    }
    
    /// Sends Configuration Message to the Node with given destination Address.
    /// The `destination` must be a Unicast Address, otherwise the method
    /// does nothing.
    ///
    /// A `delegate` method will be called when the message has been sent,
    /// delivered, or fail to be sent.
    ///
    /// - parameter message:     The message to be sent.
    /// - parameter destination: The destination Unicast Address.
    /// - throws: This method throws when the mesh network has not been created,
    ///           the local Node does not have configuration capabilities
    ///           (no Unicast Address assigned), or the destination address
    ///           is not a Unicast Address or it belongs to an unknown Node.
    ///           Error `AccessError.cannotDelete` is sent when trying to
    ///           delete the last Network Key on the device.
    func send(_ message: ConfigMessage, to destination: Address) throws {
        guard let networkManager = networkManager, let meshNetwork = meshNetwork else {
            print("Error: Mesh Network not created")
            throw MeshNetworkError.noNetwork
        }
        guard let localProvisioner = meshNetwork.localProvisioner,
              localProvisioner.hasConfigurationCapabilities else {
            print("Error: Local Provisioner has no Unicast Address assigned")
            throw AccessError.invalidSource
        }
        guard destination.isUnicast else {
            print("Error: Address: 0x\(destination.hex) is not a Unicast Address")
            throw MeshMessageError.invalidAddress
        }
        guard let node = meshNetwork.node(withAddress: destination) else {
            print("Error: Unknown destination Node")
            throw AccessError.invalidDestination
        }
        guard let _ = node.networkKeys.first else {
            print("Fatal Error: The target Node does not have Network Key")
            throw AccessError.invalidDestination
        }
        if message is ConfigNetKeyDelete {
            guard node.networkKeys.count > 2 else {
                print("Error: Cannot remove last Network Key")
                throw AccessError.cannotDelete
            }
        }
        queue.async {
            networkManager.send(message, to: destination)
        }
    }
    
    /// Sends Configuration Message to the given Node.
    ///
    /// A `delegate` method will be called when the message has been sent,
    /// delivered, or fail to be sent.
    ///
    /// - parameter message: The message to be sent.
    /// - parameter node:    The destination Node.
    /// - throws: This method throws when the mesh network has not been created,
    ///           the local Node does not have configuration capabilities
    ///           (no Unicast Address assigned), or the destination address
    ///           is not a Unicast Address or it belongs to an unknown Node.
    func send(_ message: ConfigMessage, to node: Node) throws {
        try send(message, to: node.unicastAddress)
    }
    
    /// Sends Configuration Message to the given Node.
    ///
    /// A `delegate` method will be called when the message has been sent,
    /// delivered, or fail to be sent.
    ///
    /// - parameter message: The message to be sent.
    /// - parameter element: The destination Element.
    /// - throws: This method throws when the mesh network has not been created,
    ///           the local Node does not have configuration capabilities
    ///           (no Unicast Address assigned), or the target Element does not
    ///           belong to any known Node.
    func send(_ message: ConfigMessage, to element: Element) throws {
        guard let node = element.parentNode else {
            print("Error: Element does not belong to a Node")
            throw AccessError.invalidDestination
        }
        try send(message, to: node)
    }
    
    /// Sends Configuration Message to the given Node.
    ///
    /// A `delegate` method will be called when the message has been sent,
    /// delivered, or fail to be sent.
    ///
    /// - parameter message: The message to be sent.
    /// - parameter model:   The destination Model.
    /// - throws: This method throws when the mesh network has not been created,
    ///           the local Node does not have configuration capabilities
    ///           (no Unicast Address assigned), or the target Element does
    ///           not belong to any known Node.
    func send(_ message: ConfigMessage, to model: Model) throws {
        guard let element = model.parentElement else {
            print("Error: Model does not belong to an Element")
            throw AccessError.invalidDestination
        }
        try send(message, to: element)
    }
    
    /// Sends the Proxy Configuration Message to the connected Proxy Node.
    ///
    /// This method will only work if the bearer uses is GATT Proxy.
    /// The message will be encrypted and sent to the `transported`, which
    /// should deliver the PDU to the connected Node.
    ///
    /// - parameter message: The Proxy Configuration message to be sent.
    /// - throws: This method throws when the mesh network has not been created.
    func send(_ message: ProxyConfigurationMessage) throws {
        guard let networkManager = networkManager else {
            print("Error: Mesh Network not created")
            throw MeshNetworkError.noNetwork
        }
        queue.async {
            networkManager.send(message)
        }
    }
    
}

// MARK: - Helper methods for Bearer support

extension MeshNetworkManager: BearerDataDelegate {
    
    public func bearer(_ bearer: Bearer, didDeliverData data: Data, ofType type: PduType) {
        bearerDidDeliverData(data, ofType: type)
    }
    
}

// MARK: - Save / Load

public extension MeshNetworkManager {
    
    /// Loads the Mesh Network configuration from the storage.
    /// If storage is not given, a local file will be used.
    ///
    /// - returns: `True` if the network settings were loaded, `false` otherwise.
    /// - throws: If loading configuration failed.
    func load() throws -> Bool {
        if let data = storage.load() {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            meshData = try decoder.decode(MeshData.self, from: data)
            guard let meshNetwork = meshData.meshNetwork else {
                return false
            }
            meshNetwork.provisioners.forEach {
                $0.meshNetwork = meshNetwork
            }
            // This will reset the local Elements. They have to be set again
            // by the app after the network was loaded.
            meshNetwork.localElements = []
            
            networkManager = NetworkManager(self)
            proxyFilter = ProxyFilter(self)
            return true
        }
        return false
    }
    
    /// Saves the Mesh Network configuration in the storage.
    /// If storage is not given, a local file will be used.
    ///
    /// - returns: `True` if the network settings was saved, `false` otherwise.
    func save() -> Bool {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        let data = try! encoder.encode(meshData)
        return storage.save(data)
    }
    
}

// MARK: - Export / Import
    
public extension MeshNetworkManager {
    
    /// Returns the exported Mesh Network configuration as JSON Data.
    /// The returned Data can be transferred to another application and
    /// imported. The JSON is compatible with Bluetooth Mesh scheme.
    ///
    /// - returns: The mesh network configuration as JSON Data.
    func export() -> Data {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        return try! encoder.encode(meshData.meshNetwork)
    }
    
    /// Imports the Mesh Network configuration from the given Data.
    /// The data must contain valid JSON with Bluetooth Mesh scheme.
    ///
    /// - parameter data: JSON as Data.
    /// - throws: This method throws an error if import or adding
    ///           the local Provisioner failed.
    func `import`(from data: Data) throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let meshNetwork = try decoder.decode(MeshNetwork.self, from: data)
        meshNetwork.provisioners.forEach {
            $0.meshNetwork = meshNetwork
        }
        // This will reset the local Elements. They have to be set again
        // by the app after the network was imported.
        meshNetwork.localElements = []
        
        meshData.meshNetwork = meshNetwork
        networkManager = NetworkManager(self)
        proxyFilter = ProxyFilter(self)
    }
    
}
