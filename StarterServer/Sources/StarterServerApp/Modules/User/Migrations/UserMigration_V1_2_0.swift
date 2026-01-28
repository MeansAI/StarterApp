//
//  File.swift
//
//
//  Created by Justin Means on 6/8/23.
//

import Fluent
import Foundation
import JWS
import Vapor

struct UserMigration_V1_2_0: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(UserModel.schema)
            .field(JWSFieldKey.phone, .string)
            .field(JWSFieldKey.phoneConfirmed, .bool)
            .field(JWSFieldKey.emailConfirmed, .bool)
            .update()
    }

    func revert(on database: Database) async throws {
        try await database.schema(UserModel.schema)
            .deleteField(JWSFieldKey.phone)
            .deleteField(JWSFieldKey.phoneConfirmed)
            .deleteField(JWSFieldKey.emailConfirmed)
            .update()
    }
}
