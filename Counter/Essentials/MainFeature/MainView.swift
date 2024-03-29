//
//  MainView.swift
//  Counter
//
//  Created by Ara Hakobyan on 1/11/24.
//

import ComposableArchitecture
import SwiftUI

struct MainView: View {
    let store: StoreOf<MainFeature>
    
    var body: some View {
        TabView {
            CounterView(store: store.scope(state: \.tab1, action: \.tab1))
                .tabItem {
                    Text("Counter 1")
                }
            
            CounterView(store: store.scope(state: \.tab2, action: \.tab2))
                .tabItem {
                    Text("Counter 2")
                }
        }
    }
}

#Preview {
    MainView(
      store: Store(initialState: MainFeature.State()) {
        MainFeature()
      }
    )
  }
