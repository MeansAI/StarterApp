import Foundation
import JCS
import SwiftUI

public struct StarterAppAuthUser: JCSAuthUserRepresentable {
    public typealias Micro = User.Micro
    public typealias Global = User.Global
    public typealias Personal = User.Personal
    public typealias Put = User.Put
    public typealias Create = User.CreateData
}

@MainActor
public final class Network: JCSAuthBase, JCSCore, JCSAuthCore {
    public typealias JCSAuthUser = StarterAppAuthUser
    public typealias GlobalDevice = AuthDeviceGlobal
    public typealias MyInterface = Interface

    public override init() {
        super.init()
    }

    public nonisolated static var debuggerLevel: JCSDebugLevel { .production }
    public nonisolated static var apiURL: String { "https://\(apiBase)" }
    public nonisolated static var apiBase: String { "api.example.com" }  // TODO: Configure your API
    public nonisolated static var keychainTokenKey: String { "ai.means.starterapp.authToken" }

    public nonisolated let urlSession: URLSession = URLSession(configuration: .default)

    public weak var interface: Interface?

    @Persisted(encodedDataKey: "starterapp_user") public var user: User.Personal? { willSet {
        objectWillChange.send()
    }}

    public var privacyPolicy: URL { URL(string: "https://example.com/privacy")! }
    public var termsOfService: URL { URL(string: "https://example.com/terms")! }

    public func errorOccurred(_ message: String?, debugLevel: JCSDebugLevel) {
        guard debugLevel.rawValue <= Self.debuggerLevel.rawValue else { return }
        if let message {
            jlog("[Network Error] \(message)")
        }
    }

    public func logout() {
        authLogout()
        DispatchQueue.main.async {
            self.user = nil
        }
    }

    public func greet() async throws {
        try await authGreet()
        if let token = try? retrieveToken() {
            let user = try await authGetUserWithToken(token: token)
            await MainActor.run {
                self.user = user
            }
        }
    }

    public func reAuth() async throws {
        if let token = try? retrieveToken() {
            let user = try await authGetUserWithToken(token: token)
            await MainActor.run {
                self.user = user
            }
        }
    }

    public func createUser(registrationData: User.CreateData) async throws {
        let user = try await authCreateUser(registrationData: registrationData)
        await MainActor.run {
            self.user = user
        }
    }

    public func login(credentials: Credentials) async throws {
        let user = try await authLoginUser(credentials: credentials)
        await MainActor.run {
            self.user = user
        }
    }

    public func authorizeSIWA(identityToken: Data?, email: String?, fullName: String?, firstName: String?, lastName: String?) async throws {
        let user = try await authAuthorizeSIWA(identityToken: identityToken, email: email, fullName: fullName, firstName: firstName, lastName: lastName)
        await MainActor.run {
            self.user = user
        }
    }

    public func searchAction(result _: any SearchResultRepresentable) {}

    public func search(text: String) async throws -> [any SearchResultRepresentable] {
        []
    }
}

extension Network: URLSessionDelegate {}
