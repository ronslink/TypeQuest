import SwiftUI
import StoreKit

/// PaywallView displays subscription options to unlock Pro features
struct PaywallView: View {
    
    // MARK: - Environment
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var storeManager = StoreManager.shared
    
    // MARK: - State
    
    @State private var selectedProductID: String = "com.typequest.pro.yearly"
    @State private var isPurchasing = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showRestoreAlert = false
    @State private var restoreSuccess = false
    
    // MARK: - Computed Properties
    
    private var monthlyProduct: Product? {
        storeManager.products.first { $0.id == "com.typequest.pro.monthly" }
    }
    
    private var yearlyProduct: Product? {
        storeManager.products.first { $0.id == "com.typequest.pro.yearly" }
    }
    
    private var selectedProduct: Product? {
        selectedProductID == "com.typequest.pro.yearly" ? yearlyProduct : monthlyProduct
    }
    
    private var yearlySavingsPercent: Int {
        guard let monthly = monthlyProduct, let yearly = yearlyProduct else { return 0 }
        let monthlyCost = monthly.price
        let yearlyCost = yearly.price
        let yearlyIfMonthly = monthlyCost * 12
        let savings = ((yearlyIfMonthly - yearlyCost) / yearlyIfMonthly) * 100
        return Int(NSDecimalNumber(decimal: savings).doubleValue)
    }
    
    // MARK: - Constants
    
    private let features = [
        PaywallFeature(icon: "star.fill", title: "All Stages Unlocked", description: "Access stages 3-6 and beyond"),
        PaywallFeature(icon: "paintpalette.fill", title: "Premium Themes", description: "Unlock exclusive color schemes"),
        PaywallFeature(icon: "chart.line.uptrend.xyaxis", title: "Advanced Statistics", description: "Deep insights into your progress"),
        PaywallFeature(icon: "gamecontroller.fill", title: "Game Modes", description: "Rain, Racer, and RPG modes"),
        PaywallFeature(icon: "trophy.fill", title: "Leaderboards", description: "Compete globally with Game Center")
    ]
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                headerSection
                
                // Features
                featuresSection
                
                // Subscription Options
                subscriptionSection
                
                // Action Buttons
                actionButtonsSection
                
                // Footer
                footerSection
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
        }
        .background(Color(nsColor: .windowBackgroundColor))
        .onAppear {
            // Load products if not already loaded
            if storeManager.products.isEmpty {
                Task {
                    await storeManager.fetchProducts()
                }
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .alert("Restore Purchases", isPresented: $showRestoreAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(restoreSuccess ? "Your purchases have been restored!" : "No previous purchases found.")
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "keyboard.badge.ellipsis")
                .font(.system(size: 48))
                .foregroundStyle(.orange)
            
            Text("Unlock TypeQuest Pro")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Master touch typing across all languages and layouts")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
    }
    
    // MARK: - Features Section
    
    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(features, id: \.title) { feature in
                HStack(spacing: 12) {
                    Image(systemName: feature.icon)
                        .font(.title3)
                        .foregroundStyle(.orange)
                        .frame(width: 32)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(feature.title)
                            .font(.headline)
                        
                        Text(feature.description)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 4)
            }
        }
        .padding(16)
        .background(Color(nsColor: .controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: - Subscription Section
    
    private var subscriptionSection: some View {
        VStack(spacing: 12) {
            // Monthly Option
            subscriptionCard(
                product: monthlyProduct,
                productID: "com.typequest.pro.monthly"
            )
            
            // Yearly Option (Recommended)
            yearlySubscriptionCard
        }
    }
    
    private func subscriptionCard(product: Product?, productID: String) -> some View {
        Button {
            selectedProductID = productID
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(product?.displayName ?? "Monthly")
                        .font(.headline)
                    
                    if let product = product {
                        Text(product.displayPrice)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                        
                        Text("/month")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    } else {
                        Text("Loading...")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                if selectedProductID == productID {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.orange)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        selectedProductID == productID ? Color.orange : Color.gray.opacity(0.3),
                        lineWidth: selectedProductID == productID ? 2 : 1
                    )
            )
            .background(Color(nsColor: .controlBackgroundColor))
        }
        .buttonStyle(.plain)
        .disabled(product == nil)
    }
    
    private var yearlySubscriptionCard: some View {
        Button {
            selectedProductID = "com.typequest.pro.yearly"
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Pro Yearly")
                            .font(.headline)
                        
                        Text("BEST VALUE")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.orange)
                            .clipShape(Capsule())
                    }
                    
                    if let product = yearlyProduct {
                        let monthlyEquivalent = product.price / 12
                        Text("相当于 \(monthlyEquivalent, specifier: "%.2f")/月")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Text(product.displayPrice)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                        
                        Text("/year")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        if yearlySavingsPercent > 0 {
                            Text("节省 \(yearlySavingsPercent)%")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(.green)
                        }
                    } else {
                        Text("Loading...")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                if selectedProductID == "com.typequest.pro.yearly" {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.orange)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        selectedProductID == "com.typequest.pro.yearly" ? Color.orange : Color.gray.opacity(0.3),
                        lineWidth: selectedProductID == "com.typequest.pro.yearly" ? 2 : 1
                    )
            )
            .background(
                LinearGradient(
                    colors: [Color.orange.opacity(0.1), Color.orange.opacity(0.05)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
            )
        }
        .buttonStyle(.plain)
        .disabled(yearlyProduct == nil)
    }
    
    // MARK: - Action Buttons Section
    
    private var actionButtonsSection: some View {
        VStack(spacing: 12) {
            // Subscribe Button
            Button {
                purchaseSelectedProduct()
            } label: {
                HStack {
                    if isPurchasing || storeManager.isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .scaleEffect(0.8)
                            .tint(.white)
                    } else {
                        Text("立即订阅")
                            .font(.headline)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.orange)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(isPurchasing || storeManager.isLoading || selectedProduct == nil)
            .opacity(selectedProduct == nil ? 0.6 : 1)
            
            // Restore Purchases
            Button {
                restorePurchases()
            } label: {
                Text("恢复购买")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    // MARK: - Footer Section
    
    private var footerSection: some View {
        VStack(spacing: 8) {
            Text("订阅将自动续订除非在当前期结束前24小时取消")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 4) {
                Link("隐私政策", destination: URL(string: "https://typequest.app/privacy")!)
                    .font(.caption2)
                
                Text("•")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                
                Link("服务条款", destination: URL(string: "https://typequest.app/terms")!)
                    .font(.caption2)
                
                Text("•")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                
                Link("订阅条款", destination: URL(string: "https://support.apple.com/help/subscriptions-and-reminders")!)
                    .font(.caption2)
            }
        }
        .padding(.top, 8)
    }
    
    // MARK: - Actions
    
    private func purchaseSelectedProduct() {
        guard let product = selectedProduct else { return }
        
        isPurchasing = true
        
        Task {
            do {
                try await storeManager.buy(product)
                // Check if purchase was successful
                if storeManager.isPro {
                    dismiss()
                } else if let error = storeManager.errorMessage {
                    errorMessage = error
                    showError = true
                }
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
            
            isPurchasing = false
        }
    }
    
    private func restorePurchases() {
        Task {
            do {
                try await storeManager.restorePurchases()
                
                if storeManager.isPro {
                    restoreSuccess = true
                    showRestoreAlert = true
                    // Give time to see the alert before dismissing
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    dismiss()
                } else {
                    restoreSuccess = false
                    showRestoreAlert = true
                }
            } catch {
                restoreSuccess = false
                showRestoreAlert = true
            }
        }
    }
}

// MARK: - Supporting Types

struct PaywallFeature: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
}

// MARK: - Preview

#Preview {
    PaywallView()
}
