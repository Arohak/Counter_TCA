//
//  AddContactView.swift
//  Counter
//
//  Created by Ara Hakobyan on 1/11/24.
//

import ComposableArchitecture
import SwiftUI

struct AddContactView: View {
    let store: StoreOf<AddContactFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                TextField("Name", text: viewStore.binding(get: \.contact.name, send: { .setName($0) }))
                Button("Save") {
                    viewStore.send(.saveButtonTapped)
                }
            }
            .toolbar {
                ToolbarItem {
                    Button("Cancel") {
                        viewStore.send(.cancelButtonTapped)
                    }
                }
            }
        }
    }
}

struct AddContactPreviews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddContactView(
                store: Store(
                    initialState: AddContactFeature.State(
                        contact: Contact(
                            id: UUID(),
                            name: "Blob"
                        )
                    )
                ) {
                    AddContactFeature()
                }
            )
        }
    }
}
