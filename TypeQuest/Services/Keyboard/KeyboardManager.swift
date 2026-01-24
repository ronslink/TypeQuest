import Foundation
import Cocoa
import Combine

@MainActor
final class KeyboardManager: ObservableObject {
    static let shared = KeyboardManager()
    
    @Published var isExternalKeyboardConnected: Bool = true
    @Published var activeKeyboardLayout: KeyboardLayout = .qwerty
    @Published private(set) var lastKeyPressed: String?
    @Published private(set) var lastKeyCode: UInt16?
    
    private var eventMonitor: Any?
    private var cancellables = Set<AnyCancellable>()
    
    // Callback for key events
    var onKeyDown: ((String, UInt16) -> Void)?
    var onKeyUp: ((String, UInt16) -> Void)?
    
    private init() {}
    
    // Singleton life-cycle management:
    // We don't need deinit for a singleton as it persists for the app lifetime.
    // Explicit cleanup can be done via stopMonitoring() if needed.
    
    func startMonitoring() {
        guard eventMonitor == nil else { return }
        
        // Use local event monitor (works within the app, no accessibility permission needed)
        eventMonitor = NSEvent.addLocalMonitorForEvents(matching: [.keyDown, .keyUp]) { [weak self] event in
            self?.handleKeyEvent(event)
            return event
        }
    }
    
    func stopMonitoring() {
        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
            eventMonitor = nil
        }
    }
    
    private func handleKeyEvent(_ event: NSEvent) {
        let keyCode = event.keyCode
        let characters = event.characters ?? ""
        
        DispatchQueue.main.async { [weak self] in
            self?.lastKeyCode = keyCode
            self?.lastKeyPressed = characters
            
            if event.type == .keyDown {
                self?.onKeyDown?(characters, keyCode)
                NotificationCenter.default.post(
                    name: .keyDidPress,
                    object: nil,
                    userInfo: ["characters": characters, "keyCode": keyCode]
                )
            } else if event.type == .keyUp {
                self?.onKeyUp?(characters, keyCode)
                NotificationCenter.default.post(
                    name: .keyDidRelease,
                    object: nil,
                    userInfo: ["characters": characters, "keyCode": keyCode]
                )
            }
        }
    }
    
    /// Converts a keyCode to its corresponding character for QWERTY layout
    func character(for keyCode: UInt16) -> String? {
        let keyMap: [UInt16: String] = [
            0: "a", 1: "s", 2: "d", 3: "f", 4: "h", 5: "g", 6: "z", 7: "x",
            8: "c", 9: "v", 11: "b", 12: "q", 13: "w", 14: "e", 15: "r",
            16: "y", 17: "t", 18: "1", 19: "2", 20: "3", 21: "4", 22: "6",
            23: "5", 24: "=", 25: "9", 26: "7", 27: "-", 28: "8", 29: "0",
            30: "]", 31: "o", 32: "u", 33: "[", 34: "i", 35: "p", 37: "l",
            38: "j", 39: "'", 40: "k", 41: ";", 42: "\\", 43: ",", 44: "/",
            45: "n", 46: "m", 47: ".", 49: " ", 51: "⌫"
        ]
        return keyMap[keyCode]
    }
}

extension Notification.Name {
    static let keyDidPress = Notification.Name("keyDidPress")
    static let keyDidRelease = Notification.Name("keyDidRelease")
}
