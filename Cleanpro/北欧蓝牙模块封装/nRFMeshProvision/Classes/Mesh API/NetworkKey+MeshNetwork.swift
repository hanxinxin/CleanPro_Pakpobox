//
//  NetworkKey+MeshNetwork.swift
//  nRFMeshProvision
//
//  Created by Aleksander Nowakowski on 08/05/2019.
//

import Foundation

public extension NetworkKey {
    
    /// Returns whether the Network Key is the Primary Network Key.
    /// The Primary key is the one which Key Index is equal to 0.
    ///
    /// A Primary Network Key may not be removed from the mesh network.
    var isPrimary: Bool {
        return index == 0
    }
    
    /// Return whether the Network Key is used in the given mesh network.
    ///
    /// A `true` is returned when the Network Key is added to Network Keys
    /// array of the network and is known to at least one node, or bound
    /// to an existing Application Key.
    ///
    /// An used Network Key may not be removed from the network.
    ///
    /// - parameter meshNetwork: The mesh network to look the key in.
    /// - returns: `True` if the key is used in the given network,
    ///            `false` otherwise.
    func isUsed(in meshNetwork: MeshNetwork) -> Bool {
        let localProvisioner = meshNetwork.localProvisioner
        return meshNetwork.networkKeys.contains(self) &&
            (
                // Network Key known by at least one node (except the local Provisioner).
                meshNetwork.nodes.filter({ $0.uuid != localProvisioner?.uuid }).knows(networkKey: self) ||
                // Network Key bound to an Application Key.
                meshNetwork.applicationKeys.contains(keyBoundTo: self)
            )
    }
    
}
