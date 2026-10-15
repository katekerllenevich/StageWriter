import SwiftUI
import AppKit

struct WindowConfigurator: NSViewRepresentable {
    let configure: (NSWindow) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(configure: configure)
    }

    func makeNSView(context: Context) -> NSView {
        let view = NSView()

        DispatchQueue.main.async {
            context.coordinator.attach(view.window)
        }

        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        context.coordinator.configure = configure
        context.coordinator.attach(nsView.window)
    }

    final class Coordinator {
        var configure: (NSWindow) -> Void

        private weak var window: NSWindow?
        private var observers: [any NSObjectProtocol] = []

        init(configure: @escaping (NSWindow) -> Void) {
            self.configure = configure
        }

        func attach(_ window: NSWindow?) {
            guard let window else { return }
            if self.window === window {
                configure(window)
                return
            }

            detach()
            self.window = window
            configure(window)

            for name in [NSWindow.didBecomeKeyNotification, NSWindow.didBecomeMainNotification, NSWindow.didEndSheetNotification] {
                let observer = NotificationCenter.default.addObserver(
                    forName: name,
                    object: window,
                    queue: .main
                ) { [weak self] _ in
                    guard let self, let window = self.window else { return }
                    DispatchQueue.main.async {
                        self.configure(window)
                    }
                }
                observers.append(observer)
            }
        }

        private func detach() {
            for observer in observers {
                NotificationCenter.default.removeObserver(observer)
            }

            observers.removeAll()
            window = nil
        }

        deinit {
            detach()
        }
    }
}
