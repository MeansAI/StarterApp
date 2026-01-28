//
//  File.swift
//
//
//  Created by Justin Means on 1/25/22.
//

import Foundation
import JBS

public struct AuthDeviceGlobal: AuthDeviceGlobalRepresentable {
    public init(user: User.Micro, id: UUID?, system: OperatingSystem, osVersion: String, pushToken: String?, channels: [String]) {
        self.user = user
        self.id = id
        self.system = system
        self.osVersion = osVersion
        self.pushToken = pushToken
        self.channels = channels
    }

    public typealias UserMicro = User.Micro
    public var user: User.Micro
    public var system: OperatingSystem
    public var osVersion: String
    public var pushToken: String?
    public var channels: [String]
    public var id: UUID?
}
