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
            "version": "Version",
            "arcade_mode": "Arcade Mode",
            "rain_mode": "Rain Mode",
            "rain_desc": "Type the falling letters before they hit the ground. Don't lose your lives!",
            "racer_mode": "Typing Racer",
            "racer_desc": "Competitive racing against AI bots. Speed is key!",
            "spell_caster": "Spell Caster",
            "spell_desc": "Cast spells to defeat the Syntax Bug! Type fast to survive.",
            "locked": "Locked",
            "start_battle": "Start Battle",
            "victory": "VICTORY",
            "defeat": "DEFEAT"
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
            "version": "Versión",
            "arcade_mode": "Modo Arcade",
            "rain_mode": "Modo Lluvia",
            "rain_desc": "Escribe las letras que caen antes de que toquen el suelo. ¡No pierdas vidas!",
            "racer_mode": "Carrera de Mecanografía",
            "racer_desc": "Carrera competitiva contra bots. ¡La velocidad es clave!",
            "spell_caster": "Lanzador de Hechizos",
            "spell_desc": "¡Lanza hechizos para derrotar al Bug de Sintaxis! Escribe rápido para sobrevivir.",
            "locked": "Bloqueado",
            "start_battle": "Iniciar Batalla",
            "victory": "VICTORIA",
            "defeat": "DERROTA"
        ],
        "fr": [
            "settings": "Paramètres",
            "account": "Compte",
            "language_region": "Langue et Région",
            "content_language": "Langue du Contenu",
            "keyboard_layout": "Disposition du Clavier",
            "appearance": "Apparence",
            "audio": "Audio",
            "sound_effects": "Effets Sonores",
            "background_music": "Musique de Fond",
            "reset_progress": "Réinitialiser la Progression",
            "version": "Version",
            "arcade_mode": "Mode Arcade",
            "rain_mode": "Mode Pluie",
            "rain_desc": "Tapez les lettres qui tombent avant qu'elles ne touchent le sol.",
            "racer_mode": "Course de Frappe",
            "racer_desc": "Course compétitive contre des bots. La vitesse est la clé !",
            "spell_caster": "Lanceur de Sorts",
            "spell_desc": "Lancez des sorts pour vaincre le Bug de Syntaxe ! Tapez vite.",
            "locked": "Verrouillé",
            "start_battle": "Commencer le Combat",
            "victory": "VICTOIRE",
            "defeat": "DÉFAITE"
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
            "version": "Version",
            "arcade_mode": "Arcade-Modus",
            "rain_mode": "Regen-Modus",
            "rain_desc": "Tippe die fallenden Buchstaben, bevor sie den Boden berühren.",
            "racer_mode": "Tipp-Rennen",
            "racer_desc": "Wettrennen gegen KI-Bots. Geschwindigkeit ist alles!",
            "spell_caster": "Zauberer",
            "spell_desc": "Wirke Zauber, um den Syntax-Bug zu besiegen! Tippe schnell.",
            "locked": "Gesperrt",
            "start_battle": "Kampf Starten",
            "victory": "SIEG",
            "defeat": "NIEDERLAGE"
        ],
        "nl": [
            "settings": "Instellingen",
            "account": "Account",
            "language_region": "Taal & Regio",
            "content_language": "Inhoudstaal",
            "keyboard_layout": "Toetsenbordindeling",
            "appearance": "Uiterlijk",
            "audio": "Audio",
            "sound_effects": "Geluidseffecten",
            "background_music": "Achtergrondmuziek",
            "reset_progress": "Reset Voortgang",
            "version": "Versie",
            "arcade_mode": "Arcade Modus",
            "rain_mode": "Regen Modus",
            "rain_desc": "Typ de vallende letters voordat ze de grond raken.",
            "racer_mode": "Typrace",
            "racer_desc": "Race tegen bots. Snelheid is alles!",
            "spell_caster": "Toverspreuken",
            "spell_desc": "Vecht tegen de Syntax Bug! Typ snel om te overleven.",
            "locked": "Vergrendeld",
            "start_battle": "Start Gevecht",
            "victory": "OVERWINNING",
            "defeat": "VERLIES"
        ],
        "it": [
            "settings": "Impostazioni",
            "account": "Account",
            "language_region": "Lingua e Regione",
            "content_language": "Lingua dei Contenuti",
            "keyboard_layout": "Layout Tastiera",
            "appearance": "Aspetto",
            "audio": "Audio",
            "sound_effects": "Effetti Sonori",
            "background_music": "Musica di Sottofondo",
            "reset_progress": "Resetta Progressi",
            "version": "Versione",
            "arcade_mode": "Modalità Arcade",
            "rain_mode": "Modalità Pioggia",
            "rain_desc": "Digita le lettere che cadono prima che tocchino terra.",
            "racer_mode": "Gara di Digitazione",
            "racer_desc": "Gareggia contro i bot. La velocità è fondamentale!",
            "spell_caster": "Incantatore",
            "spell_desc": "Lancia incantesimi per sconfiggere il Bug di Sintassi!",
            "locked": "Bloccato",
            "start_battle": "Inizia Battaglia",
            "victory": "VITTORIA",
            "defeat": "SCONFITTA"
        ],
        "pl": [
            "settings": "Ustawienia",
            "account": "Konto",
            "language_region": "Język i Region",
            "content_language": "Język Treści",
            "keyboard_layout": "Układ Klawiatury",
            "appearance": "Wygląd",
            "audio": "Dźwięk",
            "sound_effects": "Efekty Dźwiękowe",
            "background_music": "Muzyka w Tle",
            "reset_progress": "Zresetuj Postępy",
            "version": "Wersja",
            "arcade_mode": "Tryb Arcade",
            "rain_mode": "Tryb Deszczu",
            "rain_desc": "Wpisuj spadające litery, zanim dotkną ziemi.",
            "racer_mode": "Wyścig Pisania",
            "racer_desc": "Ścigaj się z botami. Szybkość jest kluczem!",
            "spell_caster": "Rzucanie Zaklęć",
            "spell_desc": "Rzucaj zaklęcia, aby pokonać Błąd Składni!",
            "locked": "Zablokowane",
            "start_battle": "Rozpocznij Walkę",
            "victory": "ZWYCIĘSTWO",
            "defeat": "PORAŻKA"
        ],
        "cs": [
            "settings": "Nastavení",
            "account": "Účet",
            "language_region": "Jazyk a Oblast",
            "content_language": "Jazyk Obsahu",
            "keyboard_layout": "Rozložení Klávesnice",
            "appearance": "Vzhled",
            "audio": "Zvuk",
            "sound_effects": "Zvukové Efekty",
            "background_music": "Hudba na Pozadí",
            "reset_progress": "Obnovit Postup",
            "version": "Verze",
            "arcade_mode": "Arkádový Režim",
            "rain_mode": "Režim Deště",
            "rain_desc": "Pište padající písmena, než dopadnou na zem.",
            "racer_mode": "Závod v Psaní",
            "racer_desc": "Závod proti botům. Rychlost je klíčová!",
            "spell_caster": "Sesilatel Kouzel",
            "spell_desc": "Sesílejte kouzla a porazte Syntaktickou Chybu!",
            "locked": "Zamčeno",
            "start_battle": "Začít Bitvu",
            "victory": "VÍTĚZSTVÍ",
            "defeat": "PROHRA"
        ],
        "sv": [
            "settings": "Inställningar",
            "account": "Konto",
            "language_region": "Språk & Region",
            "content_language": "Innehållsspråk",
            "keyboard_layout": "Tangentbordslayout",
            "appearance": "Utseende",
            "audio": "Ljud",
            "sound_effects": "Ljudeffekter",
            "background_music": "Bakgrundsmusik",
            "reset_progress": "Återställ Framsteg",
            "version": "Version",
            "arcade_mode": "Arkadläge",
            "rain_mode": "Regnläge",
            "rain_desc": "Skriv de fallande bokstäverna innan de når marken.",
            "racer_mode": "Skrivrace",
            "racer_desc": "Tävla mot botar. Snabbhet är nyckeln!",
            "spell_caster": "Besvärjare",
            "spell_desc": "Kasta trollformler för att besegra Syntaxfelet!",
            "locked": "Låst",
            "start_battle": "Starta Strid",
            "victory": "SEGER",
            "defeat": "FÖRLUST"
        ],
        "no": [
            "settings": "Innstillinger",
            "account": "Konto",
            "language_region": "Språk og Region",
            "content_language": "Innholdsspråk",
            "keyboard_layout": "Tastaturoppsett",
            "appearance": "Utseende",
            "audio": "Lyd",
            "sound_effects": "Lydeffekter",
            "background_music": "Bakgrunnsmusikk",
            "reset_progress": "Nullstill Fremgang",
            "version": "Versjon",
            "arcade_mode": "Arkad modus",
            "rain_mode": "Regnmodus",
            "rain_desc": "Skriv de fallende bokstavene før de treffer bakken.",
            "racer_mode": "Skriverace",
            "racer_desc": "Konkurrer mot roboter. Fart er viktig!",
            "spell_caster": "Trollmann",
            "spell_desc": "Kast banneord for å bekjempe syntaksfeilen!",
            "locked": "Låst",
            "start_battle": "Start Kamp",
            "victory": "SEIER",
            "defeat": "TAP"
        ],
        "da": [
            "settings": "Indstillinger",
            "account": "Konto",
            "language_region": "Sprog & Region",
            "content_language": "Indholdssprog",
            "keyboard_layout": "Tastaturlayout",
            "appearance": "Udseende",
            "audio": "Lyd",
            "sound_effects": "Lydeffekter",
            "background_music": "Baggrundsmusik",
            "reset_progress": "Nulstil Fremskridt",
            "version": "Version",
            "arcade_mode": "Arkade Tilstand",
            "rain_mode": "Regn Tilstand",
            "rain_desc": "Skriv de faldende bogstaver, før de rammer jorden.",
            "racer_mode": "Skrivningsløb",
            "racer_desc": "Ræs mod robotter. Hastighed er nøglen!",
            "spell_caster": "Troldmand",
            "spell_desc": "Kast besværgelser for at besejre Syntax-fejlen!",
            "locked": "Låst",
            "start_battle": "Start Kamp",
            "victory": "SEJR",
            "defeat": "NEDERLAG"
        ],
        "hu": [
            "settings": "Beállítások",
            "account": "Fiók",
            "language_region": "Nyelv és Régió",
            "content_language": "Tartalom Nyelve",
            "keyboard_layout": "Billentyűzetkiosztás",
            "appearance": "Megjelenés",
            "audio": "Hang",
            "sound_effects": "Hangeffektek",
            "background_music": "Háttérzene",
            "reset_progress": "Haladás Visszaállítása",
            "version": "Verzió",
            "arcade_mode": "Árkád Mód",
            "rain_mode": "Eső Mód",
            "rain_desc": "Gépelje be a leeső betűket, mielőtt földet érnek.",
            "racer_mode": "Gépelési Verseny",
            "racer_desc": "Versenyezzen botok ellen. A sebesség a kulcs!",
            "spell_caster": "Varázsló",
            "spell_desc": "Varázsoljon a Szintaktikai Hiba legyőzéséhez!",
            "locked": "Zárolva",
            "start_battle": "Csata Indítása",
            "victory": "GYŐZELEM",
            "defeat": "VERESÉGE"
        ],
        "fi": [
            "settings": "Asetukset",
            "account": "Tili",
            "language_region": "Kieli ja Alue",
            "content_language": "Sisältökieli",
            "keyboard_layout": "Näppäimistöasettelu",
            "appearance": "Ulkoasu",
            "audio": "Ääni",
            "sound_effects": "Äänitehosteet",
            "background_music": "Taustamusiikki",
            "reset_progress": "Nollaa Edistyminen",
            "version": "Versio",
            "arcade_mode": "Pelihalli",
            "rain_mode": "Sade-tila",
            "rain_desc": "Kirjoita putoavat kirjaimet ennen kuin ne osuvat maahan.",
            "racer_mode": "Kirjoituskilpailu",
            "racer_desc": "Kilpaile botteja vastaan. Nopeus on valttia!",
            "spell_caster": "Loitsija",
            "spell_desc": "Luo loitsuja voittaaksesi syntaksivirheen!",
            "locked": "Lukittu",
            "start_battle": "Aloita Taistelu",
            "victory": "VOITTO",
            "defeat": "HÄVIÖ"
        ],
        "el": [
            "settings": "Ρυθμίσεις",
            "account": "Λογαριασμός",
            "language_region": "Γλώσσα & Περιοχή",
            "content_language": "Γλώσσα Περιεχομένου",
            "keyboard_layout": "Διάταξη Πληκτρολογίου",
            "appearance": "Εμφάνιση",
            "audio": "Ήχος",
            "sound_effects": "Ηχητικά Εφέ",
            "background_music": "Μουσική Υπόκρουση",
            "reset_progress": "Επαναφορά Προόδου",
            "version": "Έκδοση",
            "arcade_mode": "Λειτουργία Arcade",
            "rain_mode": "Λειτουργία Βροχής",
            "rain_desc": "Πληκτρολογήστε τα γράμματα πριν πέσουν στο έδαφος.",
            "racer_mode": "Αγώνας Πληκτρολόγησης",
            "racer_desc": "Αγώνας ενάντια σε bots. Η ταχύτητα είναι το κλειδί!",
            "spell_caster": "Spell Caster",
            "spell_desc": "Κάντε ξόρκια για να νικήσετε το Σφάλμα Σύνταξης!",
            "locked": "Κλειδωμένο",
            "start_battle": "Έναρξη Μάχης",
            "victory": "ΝΙΚΗ",
            "defeat": "ΗΤΤΑ"
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
            "version": "संस्करण",
            "arcade_mode": "आर्केड मोड",
            "rain_mode": "वर्षा मोड",
            "rain_desc": "गिरते अक्षरों को जमीन पर गिरने से पहले टाइप करें।",
            "racer_mode": "टाइपिंग रेस",
            "racer_desc": "बॉट्स के खिलाफ दौड़। गति ही सब कुछ है!",
            "spell_caster": "जादूगर",
            "spell_desc": "सिंटेक्स बग को हराने के लिए मंत्र अपनाएं!",
            "locked": "बंद है",
            "start_battle": "लड़ाई शुरू करें",
            "victory": "जीत",
            "defeat": "हार"
        ],
        "ms": [
            "settings": "Tetapan",
            "account": "Akaun",
            "language_region": "Bahasa & Wilayah",
            "content_language": "Bahasa Kandungan",
            "keyboard_layout": "Susun Atur Papan Kekunci",
            "appearance": "Penampilan",
            "audio": "Audio",
            "sound_effects": "Kesan Bunyi",
            "background_music": "Muzik Latar",
            "reset_progress": "Tetapkan Semula Kemajuan",
            "version": "Versi",
            "arcade_mode": "Mod Arked",
            "rain_mode": "Mod Hujan",
            "rain_desc": "Taip huruf yang jatuh sebelum ia menyentuh tanah.",
            "racer_mode": "Perlumbaan Menaip",
            "racer_desc": "Berlumba menentang bot. Kelajuan adalah kunci!",
            "spell_caster": "Penyihir",
            "spell_desc": "Gunakan mantera untuk mengalahkan Ralat Sintaks!",
            "locked": "Terkunci",
            "start_battle": "Mula Pertarungan",
            "victory": "KEMENANGAN",
            "defeat": "KEKALAHAN"
        ],
        "tl": [
            "settings": "Mga Setting",
            "account": "Account",
            "language_region": "Wika at Rehiyon",
            "content_language": "Wika ng Nilalaman",
            "keyboard_layout": "Layout ng Keyboard",
            "appearance": "Hitsura",
            "audio": "Audio",
            "sound_effects": "Mga Tunog",
            "background_music": "Background Music",
            "reset_progress": "I-reset ang Pag-unlad",
            "version": "Bersyon",
            "arcade_mode": "Arcade Mode",
            "rain_mode": "Rain Mode",
            "rain_desc": "I-type ang mga nahuhulog na letra bago sila tumama sa lupa.",
            "racer_mode": "Typing Racer",
            "racer_desc": "Karera laban sa mga bot. Ang bilis ang susi!",
            "spell_caster": "Spell Caster",
            "spell_desc": "Cast spells upang talunin ang Syntax Bug!",
            "locked": "Naka-lock",
            "start_battle": "Simulan ang Laban",
            "victory": "TAGUMPAY",
            "defeat": "TALO"
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
