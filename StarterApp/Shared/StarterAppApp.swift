@_exported import JBS
@_exported import JCS
@_exported import JCX
@_exported import JUI
@_exported import StarterBridge
import SwiftUI

@main
struct StarterAppApp: App {
    #if os(macOS)
    class AppDelegate: NSObject, NSApplicationDelegate {
        @MainActor override init() {
            network = Network()
            interface = Interface(network: network)
        }

        let network: Network
        let interface: Interface

        func applicationDidFinishLaunching(_: Notification) {
            for window in NSApplication.shared.windows {
                window.contentView?.wantsLayer = true
                window.backgroundColor = NSColor.clear
            }
        }
    }

    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #else
    class AppDelegate: NSObject, UIApplicationDelegate {
        override init() {
            network = Network()
            interface = Interface(network: network)
        }

        let network: Network
        let interface: Interface

        func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            network.application(didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        }
    }

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif

    var body: some SwiftUI.Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appDelegate.network)
                .environmentObject(appDelegate.interface)
                .environment(\.colorScheme, .dark)
        }
        .jcsWindowGroup()
    }
}
