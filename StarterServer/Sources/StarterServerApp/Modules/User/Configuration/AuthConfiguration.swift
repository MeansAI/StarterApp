import Foundation
import JBS
import JWS
import StarterBridge
import Vapor

public struct AuthConfiguration: JWSAuthProtocol {
    public typealias AuthDevice = AuthDeviceRepresented
    public typealias AuthToken = Token
    public typealias AuthUser = AuthUserRepresented

    public static var appName: String { "StarterApp" }
    public static var app: JBSApp {
        JBSApp(
            baseURL: "https://api.example.com",  // TODO: Configure your API URL
            title: "StarterApp",
            slogan: "Your App Slogan",
            logoImageURL: "",
            iconImageURL: "",
            name: .starterApp,
            prometheusInstance: "",
            prometheusURL: ""
        )
    }
}

public struct AuthDeviceRepresented: AuthDeviceRepresentable {
    public typealias DBModel = AuthDeviceModel
    public typealias Global = AuthDeviceGlobal
}

public struct AuthUserRepresented: UserRepresentable {
    public typealias Create = User.CreateData
    public typealias DBModel = UserModel
    public typealias Global = User.Global
    public typealias Micro = User.Micro
    public typealias Personal = User.Personal
    public typealias Put = User.Put
}

extension User.Put: JWSPutUserRepresentable, Content {
    public typealias Auth = AuthConfiguration

    public func transformModel(_ oldModel: UserModel) throws -> UserModel {
        let model = oldModel
        personal.global.micro.username.map { model.username = $0 }
        model.name = personal.global.micro.name ?? ""
        personal.email.map { email in
            model.email = email
        }
        try password.map { value in
            try model.changePassword(value)
        }
        return model
    }
}

extension User.CreateData: JWSCreateUserRepresentable, Content {
    public func provideModel() throws -> UserModel {
        let model = UserModel(createData: self)
        return model
    }

    public typealias Auth = AuthConfiguration
}

extension AuthDeviceGlobal: Content {}

extension JBSAppName {
    static var starterApp: JBSAppName {
        JBSAppName(rawValue: "starterapp")
    }
}
