import Fluent
import Foundation
import JBS
import JWS
import StarterBridge
import Vapor

public final class UserModel: UserModelRepresentable, ReportableModel, @unchecked Sendable {
    init(createData: User.CreateData) {
        authIdentifier = createData.email
        email = createData.email
        username = createData.username
        password = createData.password
        name = createData.name
        hasAcceptedPrivacyPolicy = createData.hasAcceptedPrivacyPolicy
        hasAcceptedTermsAndConditions = createData.hasAcceptedTermsAndConditions
        isAnonymous = false
    }

    public init() {}

    public typealias Auth = AuthConfiguration
    public typealias RReportable = User.Micro

    public static var schema: String { "users" }

    @Field(key: JWSFieldKey.accessLevel) public var accessLevel: JBS.AccessLevel?
    @OptionalField(key: JWSFieldKey.appleUserID) public var appleUserID: String?
    @Field(key: JWSFieldKey.receiveSMS) public var receiveSMS: Bool?
    @Field(key: JWSFieldKey.receiveEmail) public var receiveEmail: Bool?
    @Field(key: JWSFieldKey.subscribedToMarketing) public var subscribedToMarketing: Bool?
    @Field(key: JWSFieldKey.dailyEngagement) public var dailyEngagement: [String: JBS.Engagement]?
    @Field(key: JWSFieldKey.emailConfirmed) public var emailConfirmed: Bool?
    @Field(key: JWSFieldKey.phone) public var phone: String?
    @Field(key: JWSFieldKey.phoneConfirmed) public var phoneConfirmed: Bool?
    @Children(for: \.$user) public var ipLogs: [GeoIPModel<AuthConfiguration>]

    public var profilePicURL: String?

    @Children(for: \.$user) public var messages: [MessageModel<AuthConfiguration>]
    @ID() public var id: UUID?
    @Siblings(through: ReportSibling<AuthConfiguration, UserModel>.self, from: \.$model, to: \.$report) public var reports: [ReportModel<Auth>]
    @Field(key: JWSFieldKey.hasAcceptedTermsAndConditions) public var hasAcceptedTermsAndConditions: Bool?
    @Field(key: JWSFieldKey.hasAcceptedPrivacyPolicy) public var hasAcceptedPrivacyPolicy: Bool?
    @Field(key: JWSFieldKey.authIdentifier) public var authIdentifier: String
    @OptionalField(key: JWSFieldKey.email) public var email: String?
    @OptionalField(key: JWSFieldKey.username) public var username: String?
    @Field(key: JWSFieldKey.password) public var password: String
    @Field(key: JWSFieldKey.name) public var name: String
    @Timestamp(key: JWSFieldKey.createdDate, on: .create) public var createdDate: Date?
    @Timestamp(key: JWSFieldKey.updatedDate, on: .update) public var updatedDate: Date?
    @Timestamp(key: JWSFieldKey.deletedDate, on: .delete) public var deletedDate: Date?
    @Timestamp(key: JWSFieldKey.lastConnected, on: .none) public var lastConnected: Date?
    @Field(key: JWSFieldKey.mostRecentOperatingSystem) public var mostRecentOperatingSystem: String?
    @Field(key: JWSFieldKey.mostRecentBinaryVersion) public var mostRecentBinaryVersion: String?

    public var appleUserIDFIeld: FluentKit.OptionalFieldProperty<UserModel, String> { $appleUserID }
    public var ipLogsField: ChildrenProperty<UserModel, GeoIPModel<AuthConfiguration>> { $ipLogs }
    public var lastConnectedField: TimestampProperty<UserModel, DefaultTimestampFormat> { $lastConnected }
    public var messagesField: ChildrenProperty<UserModel, MessageModel<AuthConfiguration>> { $messages }
    public var schema: ReportSchema { ReportSchema.user }
    public var reportsField: SiblingsProperty<UserModel, ReportModel<AuthConfiguration>, ReportSibling<AuthConfiguration, UserModel>> { $reports }
    public var devicesField: Children<AuthDeviceModel> { $devices }
    public var usernameField: OptionalFieldProperty<UserModel, String> { $username }
    public var idField: IDProperty<UserModel, UUID> { $id }
    public var authIdentifierField: FieldProperty<UserModel, String> { $authIdentifier }
    public var emailField: OptionalFieldProperty<UserModel, String> { $email }
    public var tokensField: ChildrenProperty<UserModel, Auth.AuthToken> { $tokens }
    public var hardwareField: SiblingsProperty<UserModel, HardwareModel, UserHardwareSibling<AuthConfiguration>> { $hardware }
    public var relationshipsField: SiblingsProperty<UserModel, UserModel, UserRelationshipModel<Auth>> { $relationships }

    public var micro: User.Micro {
        return User.Micro(id: id, name: name, username: username, createdDate: createdDate, isAnonymous: isAnonymous)
    }

    public static func handleReport(_: Request, report _: Report.Put) async throws -> HTTPStatus {
        return HTTPStatus.ok
    }

    public func convertInvitationsToMessages(_: Application) async throws {}

    public func deleteData(req _: Request) async throws -> HTTPStatus {
        return HTTPStatus.ok
    }

    public func getPersonal(_ req: Request) async throws -> User.Personal {
        let global = try await getGlobal(req)
        return User.Personal(
            email: email,
            token: nil,
            global: global,
            hasAcceptedTermsAndConditions: hasAcceptedTermsAndConditions ?? false,
            hasAcceptedPrivacyPolicy: hasAcceptedPrivacyPolicy ?? false
        )
    }

    public func getGlobal(_ req: Request) async throws -> User.Global {
        return User.Global(micro: micro, relationship: nil)
    }

    enum FieldKeys {
        static var admin: FieldKey { "admin" }
    }

    @Children(for: \.$user) var tokens: [Token]
    @Children(for: \.userParent) var devices: [AuthDeviceModel]
    @Siblings(through: UserRelationshipModel<Auth>.self, from: \.$fromUser, to: \.$toUser) var relationships: [UserModel]
    @Field(key: FieldKeys.admin) var admin: Bool?
    @Siblings(through: UserHardwareSibling<AuthConfiguration>.self, from: \.$user, to: \.$hardware) public var hardware: [HardwareModel]
    @OptionalField(key: JWSFieldKey.isBanned) public var isBanned: Bool?
    @OptionalField(key: JWSFieldKey.isSuspended) public var isSuspended: Bool?
    @OptionalField(key: JWSFieldKey.suspendedUntil) public var suspendedUntil: Date?
    @OptionalField(key: JWSFieldKey.bannedReason) public var bannedReason: String?
    @OptionalField(key: JWSFieldKey.suspendedReason) public var suspendedReason: String?
    @Field(key: JWSFieldKey.isAnonymous) public var isAnonymous: Bool
}

extension UserModel: Authenticatable {}

extension UserModel: SessionAuthenticatable {
    public typealias SessionID = UUID
    public var sessionID: SessionID { id! }
}

extension UserModel: ModelAuthenticatable {
    public static var usernameKey: KeyPath<UserModel, Field<String>> {
        \UserModel.$authIdentifier
    }

    public static var passwordHashKey: KeyPath<UserModel, Field<String>> {
        \UserModel.$password
    }

    public func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}

extension UserModel: Validatable {
    public static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
        validations.add("username", as: String.self, is: .count(3 ... 16) && .alphanumeric)
        validations.add("password", as: String.self, is: .count(8 ... 24) && .ascii)
        validations.add("websiteURL", as: String.self, is: .url, required: false)
        validations.add("profilePicURL", as: String.self, is: .url, required: false)
        validations.add("firstName", as: String.self, is: .characterSet(.letters), required: false)
        validations.add("lastName", as: String.self, is: .characterSet(.letters), required: false)
    }
}

extension UserModel: Content {}
extension User.Personal: Content {}
extension User.Global: Content {}
extension User.Micro: Content {}
