import SwiftUI
import Combine

class NavigationManager: ObservableObject {
    @Published var selectedTab: ContentView.NavigationItem? = .practice
    
    // Command Actions
    let restartSessionPublisher = PassthroughSubject<Void, Never>()
    let togglePausePublisher = PassthroughSubject<Void, Never>()
    
    func navigate(to tab: ContentView.NavigationItem) {
        selectedTab = tab
    }
    
    func restartSession() {
        restartSessionPublisher.send()
    }
    
    func togglePause() {
        togglePausePublisher.send()
    }
}
