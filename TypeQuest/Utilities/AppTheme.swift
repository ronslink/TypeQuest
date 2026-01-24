import SwiftUI

// MARK: - App Theme Utils

/// Centralized theme modifiers for the "Deep Ocean" aesthetic
struct AppTheme {
    
    struct Glassmorphic: ViewModifier {
        var cornerRadius: CGFloat
        var padding: CGFloat
        
        func body(content: Content) -> some View {
            content
                .padding(padding)
                .background(.ultraThinMaterial) // Native frosted glass
                .environment(\.colorScheme, .dark) // Force dark blur even in light mode if desired, or adaptive
                .cornerRadius(cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
        }
    }
    
    struct BreathingAnimation: ViewModifier {
        @State private var isBreathing = false
        
        func body(content: Content) -> some View {
            content
                .opacity(isBreathing ? 0.4 : 1.0)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                        isBreathing = true
                    }
                }
        }
    }
    
    struct StaggeredEntrance: ViewModifier {
        let delay: Double
        @State private var isVisible = false
        
        func body(content: Content) -> some View {
            content
                .opacity(isVisible ? 1.0 : 0.0)
                .offset(y: isVisible ? 0 : 20)
                .onAppear {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(delay)) {
                        isVisible = true
                    }
                }
        }
    }
    
    struct InteractivePress: ViewModifier {
        @State private var isQuished = false
        
        func body(content: Content) -> some View {
            content
                .scaleEffect(isQuished ? 0.95 : 1.0)
                .animation(.spring(response: 0.2, dampingFraction: 0.5), value: isQuished)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in isQuished = true }
                        .onEnded { _ in isQuished = false }
                )
        }
    }
}

extension View {
    func glassCard(cornerRadius: CGFloat = 16, padding: CGFloat = 20) -> some View {
        modifier(AppTheme.Glassmorphic(cornerRadius: cornerRadius, padding: padding))
    }
    
    func breathing() -> some View {
        modifier(AppTheme.BreathingAnimation())
    }
    
    func staggeredEntrance(delay: Double = 0) -> some View {
        modifier(AppTheme.StaggeredEntrance(delay: delay))
    }
    
    func interactivePress() -> some View {
        modifier(AppTheme.InteractivePress())
    }
}

// MARK: - Localization Support

@MainActor
final class Localizer: ObservableObject {
    static let shared = Localizer()
    
    @Published var currentLanguage: String = "en"
    
    private let translations: [String: [String: String]] = [
        "en": [
            "settings": "Settings",
            "account": "Account",
            "language_region": "Language & Region",
            "content_language": "Content Language",
            "keyboard_layout": "Keyboard Layout",
            "appearance": "Appearance",
            "audio": "Audio",
            "sound_effects": "Sound Effects",
            "background_music": "Background Music",
            "reset_progress": "Reset All Progress",
            "version": "Version"
        ],
        "es": [
            "settings": "Ajustes",
            "account": "Cuenta",
            "language_region": "Idioma y Región",
            "content_language": "Idioma del Contenido",
            "keyboard_layout": "Diseño de Teclado",
            "appearance": "Apariencia",
            "audio": "Audio",
            "sound_effects": "Efectos de Sonido",
            "background_music": "Música de Fondo",
            "reset_progress": "Reiniciar Progreso",
            "version": "Versión"
        ],
        "de": [
            "settings": "Einstellungen",
            "account": "Konto",
            "language_region": "Sprache & Region",
            "content_language": "Inhaltssprache",
            "keyboard_layout": "Tastaturlayout",
            "appearance": "Erscheinungsbild",
            "audio": "Audio",
            "sound_effects": "Soundeffekte",
            "background_music": "Hintergrundmusik",
            "reset_progress": "Fortschritt zurücksetzen",
            "version": "Version"
        ],
        "hi": [
            "settings": "सेटिंग्स",
            "account": "खाता",
            "language_region": "भाषा और क्षेत्र",
            "content_language": "सामग्री की भाषा",
            "keyboard_layout": "कीबोर्ड लेआउट",
            "appearance": "दिखावट",
            "audio": "ऑडियो",
            "sound_effects": "ध्वनि प्रभाव",
            "background_music": "पार्श्व संगीत",
            "reset_progress": "प्रगति रीसेट करें",
            "version": "संस्करण"
        ]
    ]
    
    func string(for key: String) -> String {
        return translations[currentLanguage]?[key] ?? translations["en"]?[key] ?? key
    }
}

extension String {
    @MainActor
    var localized: String {
        Localizer.shared.string(for: self)
    }
}

// MARK: - Monetization (StoreKit 2)

import StoreKit

@MainActor
final class StoreManager: ObservableObject {
    static let shared = StoreManager()
    
    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedProductIDs: Set<String> = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    var isPro: Bool {
        !purchasedProductIDs.isEmpty
    }
    
    private let productIDs = ["com.typequest.pro.monthly", "com.typequest.pro.yearly"]
    private var transactionListener: Task<Void, Error>?
    
    private init() {
        transactionListener = listenForTransactions()
        Task {
            await fetchProducts()
            await updatePurchasedProducts()
        }
    }
    
    deinit { transactionListener?.cancel() }
    
    func fetchProducts() async {
        do {
            products = try await Product.products(for: productIDs)
            products.sort { $0.price < $1.price }
        } catch { 
            print("StoreKit: Failed to fetch products: \(error)")
            // Don't show user error for fetch, just log it
        }
    }
    
    func buy(_ product: Product) async throws {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await updatePurchasedProducts()
                await transaction.finish()
            case .userCancelled:
                break
            case .pending:
                break
            case .pending:
                break
            @unknown default:
                break
            }
        } catch {
            errorMessage = "Purchase failed: \(error.localizedDescription)"
        }
    }
    
    func updatePurchasedProducts() async {
        var purchasedIDs: Set<String> = []
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                if transaction.revocationDate == nil { purchasedIDs.insert(transaction.productID) }
            } catch { print("StoreKit: Verification failed: \(error)") }
        }
        self.purchasedProductIDs = purchasedIDs
    }
    
    func restorePurchases() async throws {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await AppStore.sync()
            await updatePurchasedProducts()
        } catch {
            errorMessage = "Restore failed: \(error.localizedDescription)"
        }
    }
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified: throw StoreError.failedVerification
        case .verified(let safe): return safe
        }
    }
    
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try await self.checkVerified(result)
                    await self.updatePurchasedProducts()
                    await transaction.finish()
                } catch { print("StoreKit: Update verification failed: \(error)") }
            }
        }
    }
    
    enum StoreError: Error { case failedVerification }
}

// MARK: - Paywall UI

struct PaywallView: View {
    @StateObject private var storeManager = StoreManager.shared
    @Environment(\.dismiss) var dismiss
    
    @State private var showError = false
    
    var body: some View {
        ZStack {
            Color.canvasDark.ignoresSafeArea()
            VStack(spacing: 30) {
                // ... content ...
                VStack(spacing: 12) {
                    Image(systemName: "crown.fill").font(.system(size: 80))
                        .foregroundStyle(.linearGradient(colors: [.indigoPrimary, .cyanAccent], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .staggeredEntrance(delay: 0.1)
                    Text("TypeQuest Pro").font(.largeTitle).fontWeight(.bold).foregroundColor(.white).staggeredEntrance(delay: 0.2)
                    Text("Unlock Global Typing Mastery").font(.subheadline).foregroundColor(.gray).staggeredEntrance(delay: 0.3)
                }.padding(.top, 40)
                
                VStack(alignment: .leading, spacing: 16) {
                    FeatureRow(icon: "globe", text: "All 17 Languages & 6 Layouts")
                    FeatureRow(icon: "chart.bar.fill", text: "Detailed Performance Analytics")
                    FeatureRow(icon: "paintpalette.fill", text: "Exclusive Premium Themes")
                }.padding().glassCard().padding(.horizontal).staggeredEntrance(delay: 0.4)
                
                Spacer()
                
                VStack(spacing: 16) {
                    if storeManager.isLoading {
                        ProgressView().tint(.white)
                    } else {
                        ForEach(storeManager.products, id: \.id) { product in
                            Button { Task { try? await storeManager.buy(product) } } label: {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(product.displayName).fontWeight(.bold)
                                        Text(product.description).font(.caption).foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Text(product.displayPrice).fontWeight(.bold)
                                }.padding().background(Color.white.opacity(0.05)).cornerRadius(12)
                            }.buttonStyle(.plain).interactivePress()
                        }
                    }
                }.padding(.horizontal).staggeredEntrance(delay: 0.5)
                
                Button(action: { dismiss() }) {
                    Text("Maybe Later").fontWeight(.medium).foregroundColor(.white.opacity(0.6))
                }.padding(.bottom, 20).staggeredEntrance(delay: 0.6)
            }
        }
        .alert("Store Error", isPresented: $showError) {
            Button("OK", role: .cancel) { storeManager.errorMessage = nil }
        } message: {
            Text(storeManager.errorMessage ?? "Unknown error")
        }
        .onChange(of: storeManager.errorMessage) { newValue in
            if newValue != nil { showError = true }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon).foregroundColor(.cyanAccent).frame(width: 24)
            Text(text).foregroundColor(.white)
            Spacer()
        }
    }
}

// MARK: - Onboarding UI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var username: String = ""
    @State private var selectedLanguage: String = "en"
    @State private var selectedLayout: KeyboardLayout = .qwerty
    @State private var ageGroup: AgeGroup = .adult
    
    @EnvironmentObject var dataManager: DataManager
    @Binding var isOnboardingComplete: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.canvasDark.ignoresSafeArea()
            
            VStack {
                // Progress Indicator
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(index <= currentPage ? Color.indigoPrimary : Color.white.opacity(0.1))
                            .frame(width: 8, height: 8)
                            .animation(.spring(), value: currentPage)
                    }
                }
                .padding(.top, 40)
                
                Group {
                    switch currentPage {
                    case 0:
                        VStack(spacing: 30) {
                            Image(systemName: "keyboard.fill").font(.system(size: 100))
                                .foregroundStyle(.linearGradient(colors: [.indigoPrimary, .cyanAccent], startPoint: .top, endPoint: .bottom))
                                .staggeredEntrance(delay: 0.1)
                        Text("Welcome to TypeQuest").font(.largeTitle).fontWeight(.bold)
                        Text("Master touch typing in 17 languages.").foregroundColor(.gray).padding(.horizontal)
                        Button("Start Journey") { withAnimation { currentPage = 1 } }.padding(.horizontal, 40).padding(.vertical, 14).background(Color.indigoPrimary).cornerRadius(30)
                    }.transition(.move(edge: .trailing))
                
                case 1:
                    VStack(spacing: 40) {
                        Text("Regional Settings").font(.title).fontWeight(.bold)
                        VStack(alignment: .leading, spacing: 20) {
                            Picker("Language", selection: $selectedLanguage) {
                                ForEach(SupportedLanguage.allCases, id: \.self) { lang in Text(lang.displayName).tag(lang.rawValue) }
                            }.pickerStyle(.menu).glassCard()
                            Picker("Layout", selection: $selectedLayout) {
                                ForEach(KeyboardLayout.allCases, id: \.self) { layout in Text(layout.rawValue.uppercased()).tag(layout) }
                            }.pickerStyle(.menu).glassCard()
                        }.padding()
                        Button("Next") { withAnimation { currentPage = 2 } }.buttonStyle(.borderedProminent).tint(.indigoPrimary)
                    }.transition(.move(edge: .trailing))
                
                default:
                    VStack(spacing: 40) {
                        Text("The Hero's Identity").font(.title).fontWeight(.bold)
                        VStack(spacing: 24) {
                            TextField("Enter Character Name", text: $username).textFieldStyle(.plain).padding().background(Color.white.opacity(0.05)).cornerRadius(12)
                            Picker("Hero Age", selection: $ageGroup) { 
                                Text("Child").tag(AgeGroup.child)
                                Text("Teen").tag(AgeGroup.teen)
                                Text("Adult").tag(AgeGroup.adult)
                                Text("Senior").tag(AgeGroup.senior)
                            }.pickerStyle(.segmented)
                        }.padding()
                        Button("Finish Setup") { completeOnboarding() }.disabled(username.isEmpty).padding(.horizontal, 40).padding(.vertical, 14).background(username.isEmpty ? Color.gray : Color.indigoPrimary).cornerRadius(30)
                    }.transition(.move(edge: .trailing))
                }
            }
        }.foregroundColor(.white)
    }
    
    }
    
    private func completeOnboarding() {
        let profile = UserProfile(username: username, ageGroup: ageGroup, primaryLanguage: selectedLanguage)
        profile.settings = UserSettings(layout: selectedLayout, hasCompletedOnboarding: true)
        dataManager.currentUser = profile
        isOnboardingComplete = true
        dismiss()
    }
}
