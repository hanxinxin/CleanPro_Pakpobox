//
//  PBGattBearer.swift
//  nRFMeshProvision_Example
//
//  Created by Aleksander Nowakowski on 02/05/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import CoreBluetooth

open class PBGattBearer: BaseGattProxyBearer<MeshProvisioningService>, ProvisioningBearer {
    
    public override var supportedPduTypes: PduTypes {
        return [.provisioningPdu]
    }
    
}
