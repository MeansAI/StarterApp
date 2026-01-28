import Fluent
import FluentPostgresDriver
import JWS
import Vapor

public func configure(_ app: Application) throws {
    // Database configuration
    var pgConfig = PostgresConfiguration(
        url: Environment.get("DATABASE_URL") ?? "postgres://\(Environment.get("DATABASE_USERNAME") ?? "vapor_username"):\(Environment.get("DATABASE_PASSWORD") ?? "vapor_password")@\(Environment.get("DATABASE_HOST") ?? "localhost"):\(Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber)/\(Environment.get("DATABASE_NAME") ?? "vapor_database")"
    )

    if Environment.get("DISABLE_SSL") != "true" {
        pgConfig?.tlsConfiguration = .forClient(certificateVerification: .none)
    }

    app.http.server.configuration.hostname = "0.0.0.0"
    app.http.server.configuration.port = 8080
    app.databases.use(.postgres(configuration: pgConfig!), as: .psql)
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.migrations.add(SessionRecord.migration)
    app.routes.defaultMaxBodySize = "100mb"

    // Configure modules
    let modules: [Module] = [
        UserModule(),
        ModerateModule(),
    ]

    for module in modules {
        try module.configure(app)
    }

    try app.autoMigrate().wait()
}
