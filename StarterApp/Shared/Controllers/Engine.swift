import Combine
import Foundation
import JCS
import SwiftUI

public struct InterfaceColors: ColorSet {
    public static var lightShadow: Color { Color.gray.opacity(0.2) }
    public static var shadow: Color { Color.black.opacity(0.3) }
    public static var bgOn: Color { Color.black.opacity(0.8) }
    public static var bgOff: Color { Color.black.opacity(0.6) }
    public static var high: Color { Color.white }
    public static var med: Color { Color.white.opacity(0.7) }
    public static var low: Color { Color.white.opacity(0.4) }
    public static var accent: Color { Color.accentColor }
    public static var warning: Color { Color.yellow }
    public static var error: Color { Color.red }
    public static var success: Color { Color.green }
}

public struct InterfaceStyles: StyleSet {
    public static var accent: AnyShapeStyle { AnyShapeStyle(Color.accentColor) }
    public static var bgOn: AnyShapeStyle { AnyShapeStyle(Color.black.opacity(0.8)) }
    public static var bgOff: AnyShapeStyle { AnyShapeStyle(Color.black.opacity(0.6)) }
}

@MainActor
public class Interface: InterfaceEngineBase, InterfaceEngine {
    public var heartbeat: PassthroughSubject<JBS.HeartbeatEvent, Never>? { network?.heartbeat }

    init(network: Network, route: Routes = .home) {
        self.network = network
        self._route = History(wrappedValue: route)
        super.init()
        self.network?.interface = self
    }

    public weak var network: Network?

    public enum Routes: String, CaseIterable, JCS.Routeable {
        case home
        case settings
        case about

        public var title: String? {
            switch self {
            case .home: return "Home"
            case .settings: return "Settings"
            case .about: return "About"
            }
        }

        public var icon: String {
            switch self {
            case .home: return "house"
            case .settings: return "gear"
            case .about: return "info.circle"
            }
        }

        public var navigationMask: JCS.NavigationMask {
            switch self {
            case .home:
                return .none
            default:
                return .backward
            }
        }

        public var navigationUIMode: JCS.NavigationUIMode {
            .topBottom()
        }

        public var jTag: JTag? {
            switch self {
            case .home: return .home
            case .settings: return .settings
            default: return nil
            }
        }
    }

    public enum StudioRoutes: StudioRouteable {
        case main
    }

    public enum ModalRoutes: BasicRouteable {}

    public enum CommandRoutes: String, RawRepresentable, CommandRouteable {
        case main
    }

    public enum ModalMode: ModalRepresentable {
        case example

        public var dismissable: Bool { true }
    }

    public typealias Colors = InterfaceColors
    public typealias Styles = InterfaceStyles

    @Published public var commandRoute: CommandRoutes?
    @MainActor @Published public var studioRoute: StudioRoutes?
    @Published public var modalRoute: ModalRoutes?

    @MainActor @History public var route: any JCS.Routeable { willSet {
        objectWillChange.send()
    }}

    public var routeTitle: String? {
        (route as? Routes)?.title
    }

    public var routeSubTitle: String? { nil }

    public var routeHistory: JCS.History<any JCS.Routeable> {
        get { _route }
        set { _route = newValue }
    }

    public var commandItems: [JCS.BasicCommand] { [] }

    public func wordmarkLogo() -> AnyView {
        AnyView(
            Text("StarterApp")
                .lunaFont(.headline, weight: .bold, width: .expanded)
        )
    }

    public func iconLogo() -> AnyView {
        wordmarkLogo()
    }

    public func handleDeepLink(_: URL) throws {}
}

extension JTag {
    static var home: JTag { JTag(rawValue: "home") }
    static var settings: JTag { JTag(rawValue: "settings") }
}
