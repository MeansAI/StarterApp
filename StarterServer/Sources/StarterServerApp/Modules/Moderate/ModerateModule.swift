//
//  File.swift
//
//
//  Created by Justin Means on 1/28/22.
//

import Foundation
import JWS
import Vapor

struct ModerateModule: JWS.ModerateModule {
    typealias Auth = AuthConfiguration

    var controller: SendableRouteCollection? {
        ModerateController()
    }

    func configure(_ app: Application) throws {
        try configureProtocol(app)
        for migration in migrations {
            app.migrations.add(migration)
        }
        try app.routes.register(collection: controller!)
        scheduleProtocolJobs(app)
        scheduleJobs(app)
    }
}
