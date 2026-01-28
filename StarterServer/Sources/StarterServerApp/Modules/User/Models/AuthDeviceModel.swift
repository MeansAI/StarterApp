//
//  File.swift
//
//
//  Created by Justin Means on 1/28/22.
//

import Fluent
import Foundation
import JBS
import JWS
import StarterBridge
import Vapor

public final class AuthDeviceModel: AuthDeviceModelRepresentable, @unchecked Sendable {
    public init(fromPut: AuthDevicePut, withUser: UserModel) throws {
        $user.id = try withUser.requireID()
        system = fromPut.system
        osVersion = fromPut.osVersion
        pushToken = fromPut.pushToken
        channels = fromPut.channels?.toChannelsString() ?? ""
    }

    public init() {}

    public init(global: AuthDeviceGlobal) {
        system = global.system
        osVersion = global.osVersion
        pushToken = global.pushToken
        channels = global.channels.toChannelsString()
        id = global.id
    }

    public typealias Auth = AuthConfiguration

    public static let schema: String = "devices"

    @ID() public var id: UUID?
    @Field(key: AuthDeviceFieldKeys.system) public var system: OperatingSystem
    @Field(key: AuthDeviceFieldKeys.osVersion) public var osVersion: String
    @Field(key: AuthDeviceFieldKeys.pushToken) public var pushToken: String?
    @Field(key: AuthDeviceFieldKeys.channels) public var channels: String

    public var userParent: Parent<UserModel> { $user }
    public var pushTokenField: FieldProperty<AuthDeviceModel, String?> { $pushToken }
    public var channelsField: FieldProperty<AuthDeviceModel, String> { $channels }

    public func getGlobal(_ req: Request) async throws -> AuthDeviceGlobal {
        try await $user.load(on: req.db)
        return AuthDeviceGlobal(user: user.micro, id: id, system: system, osVersion: osVersion, pushToken: pushToken, channels: channels.isEmpty ? [] : channels.components(separatedBy: "\n"))
    }

    @Parent(key: AuthDeviceFieldKeys.user) var user: UserModel
}
