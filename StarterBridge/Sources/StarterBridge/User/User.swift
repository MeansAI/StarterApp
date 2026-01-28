import Foundation
import JBS

public enum User {
    public struct Global: GlobalUserRepresentable {
        public init(micro: User.Micro, relationship: RelationshipStatus? = nil) {
            self.micro = micro
            self.relationship = relationship
        }

        public typealias Micro = User.Micro

        public var micro: User.Micro
        public var relationship: RelationshipStatus?
    }

    public struct Micro: MicroUserRepresentable, Reportable {
        public init(id: UUID? = nil, name: String? = nil, username: String?, createdDate: Date?, isAnonymous: Bool? = nil) {
            self.id = id
            self.name = name
            self.username = username
            self.createdDate = createdDate
            self.isAnonymous = isAnonymous
        }

        public var profilePicURL: String?
        public var createdDate: Date?
        public var id: UUID?
        public var name: String?
        public var username: String?
        public var isAnonymous: Bool?

        public var displayName: String {
            if isAnonymous == true { return "Anonymous User" }
            return name ?? username ?? "User"
        }

        public var schema: ReportSchema { ReportSchema.user }

        public var reportMeta: ReportMetadata {
            ReportMetadata(title: name, imageURLString: nil, creatorName: name, date: createdDate)
        }
    }

    public struct Personal: PersonalUserRepresentable {
        public var hardware: JBS.Hardware?

        public init(email: String? = nil, token: String? = nil, global: User.Global, hasAcceptedTermsAndConditions: Bool, hasAcceptedPrivacyPolicy: Bool) {
            self.email = email
            self.token = token
            self.global = global
            self.hasAcceptedTermsAndConditions = hasAcceptedTermsAndConditions
            self.hasAcceptedPrivacyPolicy = hasAcceptedPrivacyPolicy
        }

        public typealias Global = User.Global

        public var emailConfirmed: Bool?
        public var phone: String?
        public var phoneConfirmed: Bool?
        public var messages: [Message]?
        public var email: String?
        public var token: String?
        public var global: User.Global
        public var hasAcceptedTermsAndConditions: Bool
        public var hasAcceptedPrivacyPolicy: Bool
    }

    public struct CreateData: CreateUserRepresentable {
        public var hardware: JBS.Hardware?

        public init(username: String?, email: String, name: String, firstName: String, lastName: String, password: String, hasAcceptedTermsAndConditions: Bool, hasAcceptedPrivacyPolicy: Bool, hardware: JBS.Hardware?) {
            self.username = username
            self.email = email
            self.name = name
            self.firstName = firstName
            self.lastName = lastName
            self.password = password
            self.hasAcceptedTermsAndConditions = hasAcceptedTermsAndConditions
            self.hasAcceptedPrivacyPolicy = hasAcceptedPrivacyPolicy
            self.hardware = hardware
        }

        public init(username: String?, email: String, password: String, name: String) {
            self.username = username
            self.email = email
            self.password = password
            self.name = name
            firstName = ""
            lastName = ""
            hasAcceptedPrivacyPolicy = true
            hasAcceptedTermsAndConditions = true
        }

        public init() {
            username = ""
            email = ""
            password = ""
            name = ""
            firstName = ""
            lastName = ""
            hasAcceptedPrivacyPolicy = true
            hasAcceptedTermsAndConditions = true
        }

        public static var useUsername: Bool { false }
        public static var useFirstLast: Bool { false }

        public var hasAcceptedTermsAndConditions: Bool
        public var hasAcceptedPrivacyPolicy: Bool
        public var firstName: String
        public var lastName: String
        public var username: String?
        public var email: String
        public var password: String
        public var name: String
    }

    @PublicInit
    public struct Put: PutUserRepresentable {
        public var personal: User.Personal
        public var password: String?
    }
}

extension User.Personal {
    public static var preview: User.Personal {
        User.Personal(
            email: "test@example.com",
            token: nil,
            global: User.Global(
                micro: User.Micro(
                    id: UUID(),
                    name: "Test User",
                    username: "testuser",
                    createdDate: Date(),
                    isAnonymous: false
                )
            ),
            hasAcceptedTermsAndConditions: true,
            hasAcceptedPrivacyPolicy: true
        )
    }
}
