import XCTest
@testable import TypeQuest

final class MetricsCalculatorTests: XCTestCase {
    
    var calculator: MetricsCalculator!
    
    override func setUp() {
        super.setUp()
        calculator = MetricsCalculator.shared
    }
    
    override func tearDown() {
        calculator = nil
        super.tearDown()
    }
    
    func testWPMCalculation() {
        // 50 characters, 0 errors, 1 minute = 10 WPM (since 5 chars = 1 word)
        let wpm = calculator.calculateWPM(characters: 50, uncorrectedErrors: 0, time: 60)
        XCTAssertEqual(wpm, 10.0, accuracy: 0.1)
        
        // 50 characters, 5 errors, 1 minute = 9 WPM ((50-5)/5 = 9 words)
        let wpmWithErrors = calculator.calculateWPM(characters: 50, uncorrectedErrors: 5, time: 60)
        XCTAssertEqual(wpmWithErrors, 9.0, accuracy: 0.1)
        
        // Zero time check
        let wpmZeroTime = calculator.calculateWPM(characters: 50, uncorrectedErrors: 0, time: 0)
        XCTAssertEqual(wpmZeroTime, 0.0)
    }
    
    func testRawAccuracy() {
        // 10 correct, 10 total = 100%
        XCTAssertEqual(calculator.calculateRawAccuracy(correct: 10, total: 10), 100.0)
        
        // 5 correct, 10 total = 50%
        XCTAssertEqual(calculator.calculateRawAccuracy(correct: 5, total: 10), 50.0)
        
        // 0 total = 100% (default safe)
        XCTAssertEqual(calculator.calculateRawAccuracy(correct: 0, total: 0), 100.0)
    }
    
    func testCorrectedAccuracy() {
        // 10 correct, 2 errors, 2 backspaces (all corrected) -> 10 / (10 + 0) = 100%
        XCTAssertEqual(calculator.calculateCorrectedAccuracy(correct: 10, errors: 2, backspaces: 2), 100.0)
        
        // 10 correct, 2 errors, 0 backspaces (uncorrected) -> 10 / (10 + 2) = 10/12 = 83.33%
        XCTAssertEqual(calculator.calculateCorrectedAccuracy(correct: 10, errors: 2, backspaces: 0), 83.333, accuracy: 0.001)
    }
}
