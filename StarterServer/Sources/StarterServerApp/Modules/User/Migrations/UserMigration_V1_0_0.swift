//
//  File.swift
//
//
//  Created by Justin Means on 1/28/22.
//

import Fluent
import Foundation
import JWS

struct UserMigration_V1_0_0: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(UserModel.schema)
            .id()
            .field(JWSFieldKey.hasAcceptedTermsAndConditions, .bool)
            .field(JWSFieldKey.hasAcceptedPrivacyPolicy, .bool)
            .field(JWSFieldKey.email, .string, .required)
            .unique(on: JWSFieldKey.email)
            .field(JWSFieldKey.password, .string, .required)
            .field(JWSFieldKey.name, .string, .required)
            .field(JWSFieldKey.username, .string, .required)
            .unique(on: JWSFieldKey.username)
            .field(JWSFieldKey.createdDate, .datetime)
            .field(JWSFieldKey.updatedDate, .datetime)
            .field(JWSFieldKey.deletedDate, .datetime)
            .field(JWSFieldKey.lastConnected, .datetime)
            .field(JWSFieldKey.mostRecentBinaryVersion, .string)
            .field(JWSFieldKey.mostRecentOperatingSystem, .string)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(UserModel.schema)
            .delete()
    }
}
