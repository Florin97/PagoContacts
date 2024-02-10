//
//  ContactsView.swift
//  ContactsRetriever
//
//  Created by Florin Velesca on 09.02.2024.
//

import SwiftUI

struct ContactsView<ViewModelType: ContactsViewModelProtocol>: View {
    
    @ObservedObject var viewModel: ViewModelType
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                ProgressView("Loading contacts")
            case .loaded(let contacts):
                HeaderView()
                    .padding([.leading, .trailing], 8)
                    .padding(.top, 16)
                List {
                    Section(header: Text("Contactele mele")) {
                        ForEach(contacts) { contact in
                            let contactViewModel = ContactViewModel(contact: contact)
                            ContactView(viewModel: contactViewModel)
                        }
                    }
                }
            case .error(let error):
                Text("Error: \(error.localizedDescription)")
            }
        }
        .task {
            await viewModel.fetchContacts()
        }
    }
}

#Preview {
    ContactsView(viewModel: ContactsViewModel())
}
