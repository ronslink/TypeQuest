import Foundation
import CloudKit

@MainActor
final class CloudKitManager: ObservableObject {
    static let shared = CloudKitManager()
    
    @Published var accountStatus: CKAccountStatus = .couldNotDetermine
    @Published var isSyncing: Bool = false
    @Published var lastSyncDate: Date?
    @Published var syncError: String?
    
    private lazy var container = CKContainer(identifier: "iCloud.com.typequest.app")
    
    private init() {
        // Defer account check to when needed (e.g. Settings view appears)
        // to avoid app launch lag.
    }
    
    func checkAccountStatus() {
        // CloudKit disabled.
        self.accountStatus = .couldNotDetermine
    }
    
    var isCloudAvailable: Bool {
        return false
    }
    
    var statusDescription: String {
        return "Cloud Sync Disabled"
    }
    
    // SwiftData handles sync automatically, but we can trigger a manual refresh
    // by calling this method to post a notification or invalidate context.
    func triggerSync() {
        // Disabled
    }
}
