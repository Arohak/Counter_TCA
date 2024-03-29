//
//  CounterView.swift
//  Counter
//
//  Created by Ara Hakobyan on 1/8/24.
//

import ComposableArchitecture
import SwiftUI

struct CounterView: View {
    let store: StoreOf<CounterFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                Section {
                    Text("\(viewStore.count)")
                    Button("Decrement") {
                        viewStore.send(.decrementButtonTapped)
                    }
                    Button("Increment") {
                        viewStore.send(.incrementButtonTapped)
                    }
                }
                
                Section {
                    Button(viewStore.isTimerRunning ? "Stop timer" : "Start timer") {
                      viewStore.send(.toggleTimerButtonTapped)
                    }
                    Button("Get fact") {
                        viewStore.send(.getFactButtonTapped)
                    }
                    if viewStore.isLoading {
                      ProgressView()
                    } else if let fact = viewStore.fact {
                      Text(fact)
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .padding()
                    }
                }
            }
        }
    }
}

#Preview {
    CounterView(
        store: Store(initialState: CounterFeature.State()) {
            CounterFeature()
        }
    )
}
