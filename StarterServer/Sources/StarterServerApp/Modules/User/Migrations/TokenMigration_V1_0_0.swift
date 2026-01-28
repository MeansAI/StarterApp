//
//  File.swift
//
//
//  Created by Justin Means on 1/28/22.
//

import Fluent
import Foundation
import JWS

struct TokenMigration_V1_0_0: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Token.schema)
            .id()
            .field(Token.FieldKeys.value, .string, .required)
            .field(Token.FieldKeys.user, .uuid, .required, .references(UserModel.schema, "id", onDelete: .cascade))
            .field(Token.FieldKeys.createdDate, .datetime)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Token.schema)
            .delete()
    }
}
