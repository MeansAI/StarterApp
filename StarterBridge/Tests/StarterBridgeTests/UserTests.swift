import Foundation
import Testing
@testable import StarterBridge

@Suite("User Model Tests")
struct UserTests {

    @Test("User.Micro initializes with all fields")
    func microInitialization() {
        let id = UUID()
        let date = Date()
        let micro = User.Micro(
            id: id,
            name: "Test User",
            username: "testuser",
            createdDate: date,
            isAnonymous: false
        )

        #expect(micro.id == id)
        #expect(micro.name == "Test User")
        #expect(micro.username == "testuser")
        #expect(micro.createdDate == date)
        #expect(micro.isAnonymous == false)
    }

    @Test("User.Micro displayName returns name when available")
    func microDisplayNameWithName() {
        let micro = User.Micro(
            id: UUID(),
            name: "John Doe",
            username: "johnd",
            createdDate: Date(),
            isAnonymous: false
        )

        #expect(micro.displayName == "John Doe")
    }

    @Test("User.Micro displayName returns username when name is nil")
    func microDisplayNameFallbackToUsername() {
        let micro = User.Micro(
            id: UUID(),
            name: nil,
            username: "johnd",
            createdDate: Date(),
            isAnonymous: false
        )

        #expect(micro.displayName == "johnd")
    }

    @Test("User.Micro displayName returns Anonymous for anonymous users")
    func microDisplayNameAnonymous() {
        let micro = User.Micro(
            id: UUID(),
            name: "Real Name",
            username: "user",
            createdDate: Date(),
            isAnonymous: true
        )

        #expect(micro.displayName == "Anonymous User")
    }

    @Test("User.Global contains micro and relationship")
    func globalInitialization() {
        let micro = User.Micro(
            id: UUID(),
            name: "Test",
            username: "test",
            createdDate: Date()
        )
        let global = User.Global(micro: micro, relationship: nil)

        #expect(global.micro.name == "Test")
        #expect(global.relationship == nil)
    }

    @Test("User.Personal contains all required fields")
    func personalInitialization() {
        let micro = User.Micro(
            id: UUID(),
            name: "Test",
            username: "test",
            createdDate: Date()
        )
        let global = User.Global(micro: micro)
        let personal = User.Personal(
            email: "test@example.com",
            token: "token123",
            global: global,
            hasAcceptedTermsAndConditions: true,
            hasAcceptedPrivacyPolicy: true
        )

        #expect(personal.email == "test@example.com")
        #expect(personal.token == "token123")
        #expect(personal.hasAcceptedTermsAndConditions == true)
        #expect(personal.hasAcceptedPrivacyPolicy == true)
    }

    @Test("User.CreateData initializes with full constructor")
    func createDataFullInit() {
        let createData = User.CreateData(
            username: "newuser",
            email: "new@example.com",
            name: "New User",
            firstName: "New",
            lastName: "User",
            password: "password123",
            hasAcceptedTermsAndConditions: true,
            hasAcceptedPrivacyPolicy: true,
            hardware: nil
        )

        #expect(createData.username == "newuser")
        #expect(createData.email == "new@example.com")
        #expect(createData.name == "New User")
        #expect(createData.password == "password123")
    }

    @Test("User.CreateData has convenience initializer")
    func createDataConvenienceInit() {
        let createData = User.CreateData(
            username: "user",
            email: "user@example.com",
            password: "pass123",
            name: "User"
        )

        #expect(createData.email == "user@example.com")
        #expect(createData.hasAcceptedTermsAndConditions == true)
        #expect(createData.hasAcceptedPrivacyPolicy == true)
    }

    @Test("User.Personal preview returns valid test data")
    func personalPreview() {
        let preview = User.Personal.preview

        #expect(preview.email == "test@example.com")
        #expect(preview.global.micro.name == "Test User")
        #expect(preview.global.micro.username == "testuser")
    }
}

@Suite("User JSON Encoding Tests")
struct UserEncodingTests {

    @Test("User.Micro encodes to JSON")
    func microEncodes() throws {
        let micro = User.Micro(
            id: UUID(),
            name: "Test",
            username: "test",
            createdDate: Date(),
            isAnonymous: false
        )

        let data = try JSONEncoder().encode(micro)
        #expect(!data.isEmpty)
    }

    @Test("User.Micro decodes from JSON")
    func microDecodes() throws {
        let id = UUID()
        let json = """
        {
            "id": "\(id.uuidString)",
            "name": "Decoded User",
            "username": "decoded",
            "isAnonymous": false
        }
        """

        let data = json.data(using: .utf8)!
        let micro = try JSONDecoder().decode(User.Micro.self, from: data)

        #expect(micro.id == id)
        #expect(micro.name == "Decoded User")
        #expect(micro.username == "decoded")
    }

    @Test("User.CreateData encodes to JSON")
    func createDataEncodes() throws {
        let createData = User.CreateData(
            username: "user",
            email: "user@test.com",
            password: "password",
            name: "User"
        )

        let data = try JSONEncoder().encode(createData)
        #expect(!data.isEmpty)

        let json = String(data: data, encoding: .utf8)!
        #expect(json.contains("user@test.com"))
    }
}
