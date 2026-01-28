//
//  File.swift
//
//
//  Created by Justin Means on 1/28/22.
//

@preconcurrency import Fluent
@preconcurrency import FluentKit
import Foundation
import JWS
@preconcurrency import Vapor

// MARK: - Token

public final class Token: AuthTokenRepresentable, @unchecked Sendable {
    public init() {}

    public init(id: UUID? = nil, value: String, userID: UserModel.IDValue) {
        self.id = id
        self.value = value
        $user.id = userID
    }

    public typealias Auth = AuthConfiguration

    public static let schema = "tokens"

    @ID() public var id: UUID?
    @Field(key: FieldKeys.value) public var value: String
    @Timestamp(key: FieldKeys.createdDate, on: .create) public var createdDate: Date?

    public var valueField: FieldProperty<Token, String> { $value }
    public var userParent: Parent<UserModel> { $user }

    enum FieldKeys {
        static var value: FieldKey { "value" }
        static var user: FieldKey { "user" }
        static var createdDate: FieldKey { "created_date" }
    }

    @Parent(key: FieldKeys.user) var user: UserModel
}

// MARK: ModelTokenAuthenticatable

extension Token: ModelTokenAuthenticatable {
    public static var valueKey: KeyPath<Token, Field<String>> {
        \Token.$value
    }
    
    public static var userKey: KeyPath<Token, Parent<UserModel>> {
        \Token.$user
    }
    
    public typealias User = UserModel
    public var isValid: Bool {
        true
    }
}

extension Token {
    static func generate(for user: UserModel) throws -> Token {
        let random = [UInt8].random(count: 16).base64
        return try Token(value: random, userID: user.requireID())
    }
}
