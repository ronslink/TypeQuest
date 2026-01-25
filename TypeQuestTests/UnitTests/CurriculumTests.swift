import XCTest
@testable import TypeQuest

@MainActor
final class CurriculumTests: XCTestCase {
    
    var viewModel: CurriculumViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = CurriculumViewModel()
        viewModel.completedLessons = []
    }
    
    func testInitialLessonIsUnlocked() {
        let firstLesson = viewModel.stages[0].modules[0].lessons[0]
        XCTAssertTrue(viewModel.isLessonUnlocked(firstLesson), "The very first lesson should always be unlocked.")
    }
    
    func testSequentialUnlockWithinStage() {
        let firstStage = viewModel.stages[0]
        let lesson1 = firstStage.modules[0].lessons[0]
        let lesson2 = firstStage.modules[0].lessons[1]
        
        XCTAssertFalse(viewModel.isLessonUnlocked(lesson2), "Lesson 2 should be locked until Lesson 1 is complete.")
        
        viewModel.markLessonComplete(lesson1.id)
        XCTAssertTrue(viewModel.isLessonUnlocked(lesson2), "Lesson 2 should unlock once Lesson 1 is completed.")
    }
    
    func testStageGatekeeperBlocksNextStage() {
        // 1. Complete ALL of Stage 1 EXCEPT the gatekeeper
        let stage1 = viewModel.stages[0]
        let stage2 = viewModel.stages[1]
        
        let allLessonsButGate = stage1.modules.flatMap { $0.lessons }.filter { !$0.isGatekeeper }
        let gatekeeper = stage1.modules.flatMap { $0.lessons }.first(where: { $0.isGatekeeper })!
        
        for lesson in allLessonsButGate {
            viewModel.markLessonComplete(lesson.id)
        }
        
        // 2. Check if first lesson of Stage 2 is still locked
        let stage2FirstLesson = stage2.modules[0].lessons[0]
        XCTAssertFalse(viewModel.isLessonUnlocked(stage2FirstLesson), "Stage 2 should be locked if Stage 1's gatekeeper is not done.")
        
        // 3. Complete Stage 1 Gatekeeper
        viewModel.markLessonComplete(gatekeeper.id)
        
        // 4. Stage 2 should now unlock
        XCTAssertTrue(viewModel.isLessonUnlocked(stage2FirstLesson), "Stage 2 should unlock once the previous stage's gatekeeper is passed.")
    }

    func testMultiLanguageCurriculumLoading() {
        // Arrange
        let catalog = LessonCatalog.shared
        
        // Act
        let enStages = catalog.generateAllStages(language: "en")
        let esStages = catalog.generateAllStages(language: "es")
        let deStages = catalog.generateAllStages(language: "de")
        let nlStages = catalog.generateAllStages(language: "nl")
        let frStages = catalog.generateAllStages(language: "fr")
        let itStages = catalog.generateAllStages(language: "it")
        let plStages = catalog.generateAllStages(language: "pl")
        let csStages = catalog.generateAllStages(language: "cs")
        let svStages = catalog.generateAllStages(language: "sv")
        let noStages = catalog.generateAllStages(language: "no")
        let daStages = catalog.generateAllStages(language: "da")
        let huStages = catalog.generateAllStages(language: "hu")
        let fiStages = catalog.generateAllStages(language: "fi")
        let elStages = catalog.generateAllStages(language: "el")
        let hiStages = catalog.generateAllStages(language: "hi")
        let msStages = catalog.generateAllStages(language: "ms")
        let tlStages = catalog.generateAllStages(language: "tl")
        
        // Assert
        XCTAssertNotEqual(enStages.first?.name, esStages.first?.name, "Spanish names should be localized.")
        XCTAssertNotEqual(enStages.first?.name, deStages.first?.name, "German names should be localized.")
        XCTAssertNotEqual(enStages.first?.name, nlStages.first?.name, "Dutch names should be localized.")
        XCTAssertNotEqual(enStages.first?.name, frStages.first?.name, "French names should be localized.")
        XCTAssertNotEqual(enStages.first?.name, itStages.first?.name, "Italian names should be localized.")
        XCTAssertNotEqual(enStages.first?.name, plStages.first?.name, "Polish names should be localized.")
        XCTAssertNotEqual(enStages.first?.name, csStages.first?.name, "Czech names should be localized.")
        XCTAssertNotEqual(enStages.first?.name, svStages.first?.name, "Swedish names should be localized.")
        XCTAssertNotEqual(enStages.first?.name, noStages.first?.name, "Norwegian names should be localized.")
        XCTAssertNotEqual(enStages.first?.name, daStages.first?.name, "Danish names should be localized.")
        XCTAssertNotEqual(enStages.first?.name, huStages.first?.name, "Hungarian names should be localized.")
        XCTAssertNotEqual(enStages.first?.name, fiStages.first?.name, "Finnish names should be localized.")
        XCTAssertNotEqual(enStages.first?.name, elStages.first?.name, "Greek names should be localized.")
        XCTAssertNotEqual(enStages.first?.name, hiStages.first?.name, "Hindi names should be localized.")
        XCTAssertNotEqual(enStages.first?.name, msStages.first?.name, "Malay names should be localized.")
        XCTAssertNotEqual(enStages.first?.name, tlStages.first?.name, "Tagalog names should be localized.")
        
        // Check a few key localized gatekeeper names
        let hiGate = hiStages[0].modules[0].lessons.first(where: { $0.isGatekeeper })
        XCTAssertTrue(hiGate?.name.contains("परीक्षण") ?? false, "Hindi gatekeeper name mismatch.")

        let msGate = msStages[0].modules[0].lessons.first(where: { $0.isGatekeeper })
        XCTAssertTrue(msGate?.name.contains("Ujian") ?? false, "Malay gatekeeper name mismatch.")

        let tlGate = tlStages[0].modules[0].lessons.first(where: { $0.isGatekeeper })
        XCTAssertTrue(tlGate?.name.contains("Pasulit") ?? false, "Tagalog gatekeeper name mismatch.")
    }
}
