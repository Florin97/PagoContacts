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
    private let contactsCacheService: ContactsCacheServiceProtocol
    
    init(contactsService: ContactsServiceProtocol = ContactsService(),
         contactsCacheService: ContactsCacheServiceProtocol = ContactsCacheService()) {
        self.contactsService = contactsService
        self.contactsCacheService = contactsCacheService
    }
    
    @MainActor
    func fetchContacts() async {
        state = .loading
        do {
            if let cachedContacts = contactsCacheService.loadCachedContacts() {
                state = .loaded(cachedContacts)
            } else {
                let contacts = try await contactsService.fetchContacts()
                contactsCacheService.cacheContacts(contacts)
                state = .loaded(contacts.filter { $0.status == .active })
            }
        } catch {
            state = .error(error)
        }
    }
}
