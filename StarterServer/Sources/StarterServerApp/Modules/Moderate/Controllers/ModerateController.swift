import Foundation
import JBS
import JWS
import Vapor

struct ModerateController: JWS.ModerateController {
    typealias Auth = AuthConfiguration

    func mapReportSchema(_ req: Request, report: Report.Put) async throws -> HTTPStatus {
        switch report.schema {
        case .user:
            return try await UserModel.report(req, report: report)
        default:
            throw Abort(.badRequest)
        }
    }

    func boot(routes: RoutesBuilder) throws {
        try preBoot(routes: routes)
    }
}
