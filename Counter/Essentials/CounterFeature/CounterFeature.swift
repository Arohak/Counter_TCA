//
//  CounterFeature.swift
//  Counter
//
//  Created by Ara Hakobyan on 1/11/24.
//

import ComposableArchitecture

@Reducer
struct CounterFeature {
    struct State: Equatable {
        var count = 0
        var fact: String?
        var isLoading = false
        var isTimerRunning = false
    }
    
    enum Action {
        case decrementButtonTapped
        case incrementButtonTapped
        case getFactButtonTapped
        case factResponse(String)
        case toggleTimerButtonTapped
        case timerTick
    }
    
    enum CancelID { case timer }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.numberFact) var numberFact
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.count -= 1
                state.fact = nil
                return .none
                
            case .getFactButtonTapped:
                state.fact = nil
                state.isLoading = true
                return .run { [count = state.count] send in
                    let fact = try await numberFact.fetch(count)
                    await send(.factResponse(fact))
                }
                
            case .incrementButtonTapped:
                state.count += 1
                state.fact = nil
                return .none
                
            case let .factResponse(fact):
                state.isLoading = false
                state.fact = fact
                return .none
                
            case .toggleTimerButtonTapped:
                state.isTimerRunning.toggle()
                if state.isTimerRunning {
                    return .run { send in
                        for await _ in clock.timer(interval: .seconds(1)) {
                            try await Task.sleep(for: .seconds(1))
                            await send(.timerTick)
                        }
                    }
                    .cancellable(id: CancelID.timer)
                } else {
                    return .cancel(id: CancelID.timer)
                }
                
            case .timerTick:
                state.count += 1
                state.fact = nil
                return .none
            }
        }
    }
}
