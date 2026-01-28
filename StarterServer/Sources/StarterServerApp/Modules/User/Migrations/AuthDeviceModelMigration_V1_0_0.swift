//
//  File.swift
//
//
//  Created by Justin Means on 1/28/22.
//

import Fluent
import Foundation
import JWS
import Vapor

struct AuthDeviceModelMigration_V1_0_0: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(AuthDeviceModel.schema)
            .id()
            .field(AuthDeviceFieldKeys.system, .string)
            .field(AuthDeviceFieldKeys.osVersion, .string)
            .field(AuthDeviceFieldKeys.pushToken, .string)
            .field(AuthDeviceFieldKeys.channels, .string)
            .field(AuthDeviceFieldKeys.user, .uuid)
            .foreignKey(AuthDeviceFieldKeys.user, references: UserModel.schema, .id, onDelete: .cascade, onUpdate: .cascade)
            .unique(on: AuthDeviceFieldKeys.pushToken)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(AuthDeviceModel.schema)
            .delete()
    }
}
