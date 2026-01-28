//
//  File.swift
//
//
//  Created by Justin Means on 1/30/22.
//

import Fluent
import Foundation

struct UserMigration_V1_1_0: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(UserModel.schema)
            .field(UserModel.FieldKeys.admin, .bool)
            .update()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(UserModel.schema)
            .deleteField(UserModel.FieldKeys.admin)
            .update()
    }
}
