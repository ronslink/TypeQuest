import Foundation

@MainActor
final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let defaults = UserDefaults.standard
    
    private enum Keys {
        static let username = "username"
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
    }
    
    private init() {}
    
    var username: String? {
        get { defaults.string(forKey: Keys.username) }
    }
    
    func setUsername(_ username: String) {
        defaults.set(username, forKey: Keys.username)
    }
    
    var hasCompletedOnboarding: Bool {
        get { defaults.bool(forKey: Keys.hasCompletedOnboarding) }
        set { defaults.set(newValue, forKey: Keys.hasCompletedOnboarding) }
    }
}
