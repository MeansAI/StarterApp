import JCS
import JUI
import SwiftUI

let topBarHeight: CGFloat = 52
let bottomBarHeight: CGFloat = 100

struct ContentView: View {
    @EnvironmentObject var interface: Interface
    @EnvironmentObject var network: Network
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            HomeView()
                .jTag(interface.route as? Interface.Routes == .home)
            SettingsView()
                .jTag(interface.route as? Interface.Routes == .settings)
            AboutView()
                .jTag(interface.route as? Interface.Routes == .about)
        }
        .animation(.jSpring, value: interface.routeTitle)
        .modifier(JCSBottomBar<Interface>(
            shadowColor: Interface.Colors.accent.opacity(Fibonacci.large.decimalValue),
            content: { BottomBarView() },
            subRouter: { _ in Group {} }
        ))
        .modifier(GaiaTopBar<Interface, Network>(
            noiseView: { EmptyView() },
            commandMenuView: { EmptyView() },
            studioView: { EmptyView() },
            logoView: {
                HStack(spacing: .xSmall) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(Interface.Colors.accent)
                    Text("StarterApp")
                        .lunaFont(.headline, weight: .bold, width: .expanded)
                }
            },
            menuButtonView: {
                Image(systemName: "magnifyingglass")
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Fibonacci.medium.wholeValue, height: Fibonacci.medium.wholeValue)
                    .padding(Fibonacci.small.wholeValue)
            },
            loaderView: {
                ProgressView()
                    .frame(width: .large, height: .large)
                    .padding(.medium)
            },
            commandAction: {}
        ))
        .modifier(JCSMain<Network, Interface>(
            modalView: { AnyView(EmptyView()) },
            overlayView: {}
        ))
        #if os(macOS)
        .background(
            BlurView(style: .hudWindow, blendingMode: .behindWindow)
                .overlay {
                    LinearGradient(
                        colors: [Color.black.opacity(0.4), Color.black.opacity(0.7)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
                .clipShape(RoundedRectangle(cornerRadius: interface.windowCornerRadius))
                .edgesIgnoringSafeArea(.all)
        )
        #else
        .background(
            LinearGradient(
                colors: [Interface.Colors.bgOff, Interface.Colors.bgOn],
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
        )
        #endif
    }
}

struct BottomBarView: View {
    @EnvironmentObject var interface: Interface

    var body: some View {
        HStack(spacing: .medium) {
            BottomBarButton(route: Interface.Routes.home)
            BottomBarButton(route: Interface.Routes.settings)
        }
        .padding(.horizontal, .medium)
    }
}

struct BottomBarButton: View {
    @EnvironmentObject var interface: Interface
    let route: Interface.Routes

    var isSelected: Bool {
        (interface.route as? Interface.Routes) == route
    }

    var body: some View {
        Button {
            interface.route = route
        } label: {
            VStack(spacing: .xSmall) {
                Image(systemName: route.icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Fibonacci.large.wholeValue, height: Fibonacci.large.wholeValue)
                Text(route.title ?? "")
                    .lunaFont(.caption2)
            }
            .foregroundStyle(isSelected ? Interface.Colors.accent : Interface.Colors.med)
        }
        .buttonStyle(.plain)
    }
}

struct HomeView: View {
    @EnvironmentObject var interface: Interface
    @EnvironmentObject var network: Network

    var body: some View {
        ScrollView {
            VStack(spacing: Fibonacci.large.wholeValue) {
                Image(systemName: "star.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Fibonacci.xxLarge.wholeValue, height: Fibonacci.xxLarge.wholeValue)
                    .foregroundStyle(Interface.Colors.accent)
                Text("Welcome to StarterApp")
                    .lunaFont(.largeTitle, weight: .bold)
                Text("Your JCS/JUI/JBS/JCX scaffold is ready")
                    .lunaFont(.body)
                    .foregroundStyle(Interface.Colors.med)
            }
            .padding()
            .padding(.top, topBarHeight)
            .padding(.bottom, bottomBarHeight)
            .frame(maxWidth: .infinity)
        }
    }
}

struct SettingsView: View {
    @EnvironmentObject var interface: Interface

    var body: some View {
        ScrollView {
            VStack(spacing: Fibonacci.large.wholeValue) {
                Image(systemName: "gear")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Fibonacci.xxLarge.wholeValue, height: Fibonacci.xxLarge.wholeValue)
                    .foregroundStyle(Interface.Colors.accent)
                Text("Settings")
                    .lunaFont(.largeTitle, weight: .bold)
                Text("Configure your app here")
                    .lunaFont(.body)
                    .foregroundStyle(Interface.Colors.med)
            }
            .padding()
            .padding(.top, topBarHeight)
            .padding(.bottom, bottomBarHeight)
            .frame(maxWidth: .infinity)
        }
    }
}

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: Fibonacci.large.wholeValue) {
                Image(systemName: "info.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Fibonacci.xxLarge.wholeValue, height: Fibonacci.xxLarge.wholeValue)
                    .foregroundStyle(Interface.Colors.accent)
                Text("About")
                    .lunaFont(.largeTitle, weight: .bold)
                Text("StarterApp v1.0.0")
                    .lunaFont(.body)
                    .foregroundStyle(Interface.Colors.med)
            }
            .padding()
            .padding(.top, topBarHeight)
            .padding(.bottom, bottomBarHeight)
            .frame(maxWidth: .infinity)
        }
    }
}
