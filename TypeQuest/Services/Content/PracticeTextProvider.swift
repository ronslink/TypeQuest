import Foundation

@MainActor
final class PracticeTextProvider {
    static let shared = PracticeTextProvider()
    
    private init() {}
    
    func sentences(for language: String) -> [String] {
        switch language.lowercased() {
        case "de":
            return germanSentences
        case "fr":
            return frenchSentences
        case "es":
            return spanishSentences
        case "it":
            return italianSentences
        default:
            return englishSentences
        }
    }
    
    // MARK: - Sentence Data
    
    private let englishSentences = [
        "The quick brown fox jumps over the lazy dog.",
        "Pack my box with five dozen liquor jugs.",
        "How vexingly quick daft zebras jump!",
        "The five boxing wizards jump quickly.",
        "Sphinx of black quartz, judge my vow.",
        "Just keep examining every low bid quoted for zinc etchings.",
        "A wizard’s job is to vex chumps quickly in fog.",
        "Watch \"Jeopardy!\", Alex Trebek's fun TV quiz game.",
        "By Jove, my quick study of lexicography won a prize!",
        "Sympathizing would fix Quaker objectives."
    ]
    
    private let germanSentences = [
        "Victor jagt zwölf Boxkämpfer quer über den großen Sylter Deich.",
        "Falsches Üben von Xylophonmusik quält jeden größeren Zwerg.",
        "Heizölrückstoßabdämpfung",
        "Die heiße Zypernsonne quälte Max und Victoria ja böse.",
        "Karl küsst Eva, wovon Papis Zorn jetzt mächtig quillt.",
        "Jeder wackere Bayer vertilgt bequem zwo Pfund Kalbshaxen.",
        "Bei jedem klugen Wort von Sokrates rief Xanthippe zynisch: Quatsch!",
        "Stanislaus jagt zwölf Boxkämpfer quer über den großen Sylter Deich.",
        "Franz jagt im komplett verwahrlosten Taxi quer durch Bayern.",
        "Zwei Boxkämpfer jagen Viktor quer über den großen Sylter Deich."
    ]
    
    private let frenchSentences = [
        "Portez ce vieux whisky au juge blond qui fume.",
        "Le vif zéphyr jubile sur les kumquats du clown gracieux.",
        "Joyeux, ivre, fluide, ce kiwi gît sur le paillasson du bazar.",
        "Voyez le brick géant que j'examine près du wharf.",
        "Monsieur Jack, vous dactylographiez bien mieux que votre ami Wolf.",
        "Zut ! Je crois que le chien a mangé tout mon whisky.",
        "L'âme sûre et la foi vive, on voit ce que l'on veut.",
        "Voix ambiguë d'un cœur qui au zéphyr préfère les jattes de kiwis.",
        "Qui veut geler ce whisky ne doit pas l'ajouter à ma vodka.",
        "Buvez de ce whisky que le patron veut sans glaçons."
    ]
    
    private let spanishSentences = [
        "Benjamín pidió una bebida de kiwi y fresa; Noé, sin vergüenza, la más exquisita champaña del menú.",
        "José compró una vieja zampoña en Perú. Excusándose, Sofía tiró su whisky al desagüe de la banqueta.",
        "El veloz murciélago hindú comía feliz cardillo y kiwi. La cigüeña tocaba el saxofón detrás del palenque de paja.",
        "Quiere la boca exhausta vid, kiwi, piña y fugaz jamón.",
        "Fabio me exige, sin tapujos, que añada cerveza al whisky.",
        "Jovencillo emponzoñado de whisky: ¡qué figurota exhibe!",
        "El pingüino Wenceslao hizo kilómetros bajo exhaustiva lluvia y frío, añoraba a su querido cachorro.",
        "Le gustaba cenar un exquisito sándwich de jamón con zumo de piña y vodka frío.",
        "Un juguetón watussi arrastró mi feliz banco por el campo.",
        "La cigüeña gigante voló por encima del pequeño jardín exhibiendo sus hermosas alas."
    ]
    
    private let italianSentences = [
        "Pranzo d'acqua fa volti sghembi.",
        "Quel fez sghembo copre davanti.",
        "Ma la volpe, col suo balzo, ha raggiunto il quieto Fido.",
        "Quel vituperabile xenofobo zelante assaggia il whisky ed esclama: alleluja!",
        "Oggi è un bel giorno per mangiare una zuppa di farro.",
        "Berlusconi ha detto che la politica è una cosa seria.",
        "Voglio un chilo di pane e due etti di prosciutto.",
        "Il cane abbaia alla luna piena nel cielo stellato.",
        "La vita è bella se sai come viverla appieno.",
        "Non dire gatto se non ce l'hai nel sacco."
    ]
}
