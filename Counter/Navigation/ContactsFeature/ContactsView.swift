//
//  ContactsView.swift
//  Counter
//
//  Created by Ara Hakobyan on 1/11/24.
//

import ComposableArchitecture
import SwiftUI

struct ContactsView: View {
    let store: StoreOf<ContactsFeature>
    
    var body: some View {
        NavigationStack {
            WithViewStore(self.store, observe: \.contacts) { viewStore in
                List {
                    ForEach(viewStore.state) { contact in
                        HStack {
                            Text(contact.name)
                            Spacer()
                            Button {
                                viewStore.send(.deleteButtonTapped(id: contact.id))
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
                .navigationTitle("Contacts")
                .toolbar {
                    ToolbarItem {
                        Button {
                            viewStore.send(.addButtonTapped)
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        }
        .sheet(
            store: self.store.scope(
                state: \.$destination.addContact,
                action: \.destination.addContact
            )
        ) { addContactStore in
            NavigationStack {
                AddContactView(store: addContactStore)
            }
        }
        .alert(
            store: self.store.scope(
                state: \.$destination.alert,
                action: \.destination.alert
            )
        )
    }
}

struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView(
            store: Store(
                initialState: ContactsFeature.State(
                    contacts: [
                        Contact(id: UUID(), name: "Blob"),
                        Contact(id: UUID(), name: "Blob Jr"),
                        Contact(id: UUID(), name: "Blob Sr"),
                    ]
                )
            ) {
                ContactsFeature()
            }
        )
    }
}
