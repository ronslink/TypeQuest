import SwiftUI

struct GameBackgroundView: View {
    let imageName: String
    
    var body: some View {
        ZStack {
            if let image = loadGameImage(named: imageName) {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
            } else {
                // Fallback Gradient if image not found
                LinearGradient(colors: [.black, .indigo.opacity(0.5)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
            }
        }
    }
    
    private func loadGameImage(named name: String) -> Image? {
        // Try exact path in Resources
        if let url = Bundle.main.url(forResource: name, withExtension: "png", subdirectory: "Resources/Images"),
           let nsImage = NSImage(contentsOf: url) {
            return Image(nsImage: nsImage)
        }
        return nil
    }
}
