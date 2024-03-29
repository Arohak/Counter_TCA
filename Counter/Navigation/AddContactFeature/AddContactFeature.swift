//
//  AddContactFeature.swift
//  Counter
//
//  Created by Ara Hakobyan on 1/11/24.
//

import ComposableArchitecture

@Reducer
struct AddContactFeature {
    struct State: Equatable {
        var contact: Contact
    }
    
    enum Action {
        case cancelButtonTapped
        case saveButtonTapped
        case setName(String)
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case saveContact(Contact)
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .cancelButtonTapped:
                return .run { _ in await dismiss() }

            case .saveButtonTapped:
                return .run { [contact = state.contact] send in
                    await send(.delegate(.saveContact(contact)))
                    await dismiss()
                }
                
            case .delegate:
                return .none
                
            case let .setName(name):
                state.contact.name = name
                return .none
            }
        }
    }
}


