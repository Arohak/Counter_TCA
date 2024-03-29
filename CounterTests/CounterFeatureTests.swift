//
//  CounterFeatureTests.swift
//  CounterTests
//
//  Created by Ara Hakobyan on 1/11/24.
//

import ComposableArchitecture
import XCTest
@testable  import Counter

@MainActor
final class CounterFeatureTests: XCTestCase {
    func testTimer() async {
        let clock = TestClock()
        
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.continuousClock = clock
        }
        
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = true
        }
        await clock.advance(by: .seconds(10))
        await store.receive(\.timerTick) {
            $0.count = 1
        }
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = false
        }
    }
    
    func testNumberFacts() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.numberFact.fetch = { "\($0) is a good number." }
        }
        
        await store.send(.getFactButtonTapped) {
            $0.isLoading = true
        }
        await store.receive(\.factResponse, timeout: .seconds(1)) {
            $0.isLoading = false
            $0.fact = "0 is a good number."
        }
    }
}
