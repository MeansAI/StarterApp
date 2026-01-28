//
//  File.swift
//
//
//  Created by Justin Means on 1/28/22.
//

import Fluent
import Foundation
import JBS
import JWS
import StarterBridge
import SotoS3
import Vapor

struct UserController: AuthController {
    typealias Auth = AuthConfiguration

    static var terms: ComplianceResponse {
        ComplianceResponse(pdfURL: "", webURL: "", title: "Terms of Service", effectiveDate: "")  // TODO: Configure
    }

    static var privacy: ComplianceResponse {
        ComplianceResponse(pdfURL: "", webURL: "", title: "Privacy Policy", effectiveDate: "")  // TODO: Configure
    }

    var fromEmailAddress: String { "StarterApp <services@example.com>" }  // TODO: Configure

    func processMessageResponse(_: Request) async throws -> MessageServerResponse {
        // TODO: Implement
        return MessageServerResponse(action: .decline, type: MessageType.invitation)
    }

    func boot(routes: RoutesBuilder) throws {
        try preBoot(routes: routes)
    }
}
