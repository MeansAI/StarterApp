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

struct UserModule: Module, AuthModule {
    typealias Auth = AuthConfiguration

    var router: SendableRouteCollection? {
        UserController()
    }

    var migrations: [Migration] {
        [
            UserMigration_V1_0_0(),
            TokenMigration_V1_0_0(),
            AuthDeviceModelMigration_V1_0_0(),
            UserMigration_V1_1_0(),
            UserMigration_V1_2_0(),
        ]
    }

    func configure(_ app: Application) throws {
        for migration in migrations {
            app.migrations.add(migration)
        }
        try app.routes.register(collection: router!)
        try configureProtocol(app)
        scheduleProtocolJobs(app)
        scheduleJobs(app)
    }
}
