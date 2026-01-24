import SwiftUI

struct OnboardingView: View {
    @Binding var isOnboardingComplete: Bool
    
    @State private var username: String = ""
    @State private var selectedLayout: KeyboardLayout = .qwerty
    @State private var selectedAgeGroup: AgeGroup = .adult
    @State private var currentStep: Int = 0
    
    // Dependencies
    private let dataManager = DataManager.shared
    private let userDefaults = UserDefaultsManager.shared
    
    var body: some View {
        ZStack {
            Color.canvasDark.ignoresSafeArea()
            
            VStack(spacing: 40) {
                // Header
                Text("TypeQuest")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .indigoPrimary, radius: 10)
                
                if currentStep == 0 {
                    // Step 1: Welcome
                    VStack(spacing: 20) {
                        Text("Master your keyboard.\nEmbark on the journey.")
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.textSecondaryDark)
                        
                        Image(systemName: "keyboard.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.indigoPrimary)
                            .padding()
                        
                        Button("Begin Journey") {
                            withAnimation { currentStep = 1 }
                        }
                        .buttonStyle(PrimaryButtonStyle())
                    }
                } else if currentStep == 1 {
                    // Step 2: Name
                    VStack(spacing: 20) {
                        Text("What should we call you?")
                            .font(.title2)
                            .foregroundColor(.white)
                        
                        TextField("Enter your name", text: $username)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding()
                            .background(Color.surfaceDark)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.indigoPrimary, lineWidth: 1))
                            .padding(.horizontal, 40)
                            .frame(maxWidth: 400)
                        
                        Button("Next") {
                            if !username.isEmpty {
                                withAnimation { currentStep = 2 }
                            }
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .disabled(username.isEmpty)
                    }
                } else if currentStep == 2 {
                    // Step 3: Age Group
                    VStack(spacing: 20) {
                        Text("Who is this for?")
                            .font(.title2)
                            .foregroundColor(.white)
                        
                        ForEach(AgeGroup.allCases, id: \.self) { age in
                            Button(action: {
                                selectedAgeGroup = age
                                withAnimation { currentStep = 3 }
                            }) {
                                HStack {
                                    Text(age.displayName)
                                        .fontWeight(.medium)
                                    Spacer()
                                    if selectedAgeGroup == age {
                                        Image(systemName: "checkmark")
                                    }
                                }
                                .padding()
                                .frame(maxWidth: 300)
                                .background(selectedAgeGroup == age ? Color.indigoPrimary : Color.surfaceDark)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                } else if currentStep == 3 {
                    // Step 4: Layout Selection
                    VStack(spacing: 20) {
                        Text("Choose your weapon")
                            .font(.title2)
                            .foregroundColor(.white)
                        
                        Picker("Layout", selection: $selectedLayout) {
                            ForEach(KeyboardLayout.allCases, id: \.self) { layout in
                                Text(layout.rawValue.uppercased()).tag(layout)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal, 40)
                        .frame(maxWidth: 400)
                        
                        Text("You can change this anytime in Settings.")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Button("Take Placement Test") {
                            // Create user first
                            let _ = dataManager.createUser(username: username, ageGroup: selectedAgeGroup, language: "en")
                            withAnimation { currentStep = 4 }
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        
                        Button("Skip Test & Start") {
                            completeOnboarding()
                        }
                        .foregroundColor(.textSecondaryDark)
                        .font(.caption)
                    }
                } else if currentStep == 4 {
                    // Step 5: Diagnostic Test
                    DiagnosticView(
                        showDiagnostic: Binding(
                            get: { currentStep == 4 },
                            set: { if !$0 { currentStep = 5 } }
                        ),
                        isOnboardingComplete: $isOnboardingComplete
                    )
                }
            }
            .padding()
        }
    }
    
    private func completeOnboarding() {
        // Save User with selected age group (if not already created)
        if dataManager.currentUser == nil {
            let _ = dataManager.createUser(username: username, ageGroup: selectedAgeGroup, language: "en")
        }
        
        // Save completion flag
        var defaults = UserDefaultsManager.shared
        defaults.hasCompletedOnboarding = true
        
        withAnimation {
            isOnboardingComplete = true
        }
    }
}

// Reusable Button Style
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding(.horizontal, 30)
            .padding(.vertical, 15)
            .background(Color.indigoPrimary)
            .foregroundColor(.white)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .shadow(color: .indigoPrimary.opacity(0.4), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    OnboardingView(isOnboardingComplete: .constant(false))
}
