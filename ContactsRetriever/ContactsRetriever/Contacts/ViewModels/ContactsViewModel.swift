//
//  ContactsViewModel.swift
//  ContactsRetriever
//
//  Created by Florin Velesca on 09.02.2024.
//

import Combine

enum LoadingState {

    case idle
    case loading
    case loaded([Contact])
    case error(Error)
}

protocol ContactsViewModelProtocol: ObservableObject {
     var state: LoadingState { get }
     func fetchContacts() async
}

class ContactsViewModel: ContactsViewModelProtocol {
    @Published private(set) var state: LoadingState = .idle
    
    private let contactsService: ContactsServiceProtocol
    
    init(contactsService: ContactsServiceProtocol = ContactsService()) {
        self.contactsService = contactsService
    }
    
    @MainActor
    func fetchContacts() async {
        state = .loading
        do {
            let contacts = try await contactsService.fetchContacts()
            state = .loaded(contacts.filter { $0.status == .active })
        } catch {
            state = .error(error)
        }
    }
}
