//
//  ContactViewModel.swift
//  ContactsRetriever
//
//  Created by Florin Velesca on 09.02.2024.
//

import SwiftUI

enum ContactState {
    case image(UIImage)
    case initials(String)
    case loading
}

class ContactViewModel: ObservableObject {
    private let contact: Contact
    private let contactService: ContactServiceProtocol
    
    @Published var state: ContactState = .loading
    var contactName: String {
        contact.name
    }
    
    init(contact: Contact, contactService: ContactServiceProtocol = ContactService()) {
        self.contact = contact
        self.contactService = contactService
    }
    
    func loadIcon() async {
        if contact.id % 2 == 0 {
            let initials = getInitials(for: contact.name)
            state = .initials(initials)
        } else {
            await showImage()
        }
    }
    
    @MainActor
    private func showImage() async {
        do {
            if let image = try await contactService.fetchImage() {
                state = .image(image)
            } else {
                let initials = getInitials(for: contact.name)
                state = .initials(initials)
            }
        } catch {
            let initials = getInitials(for: contact.name)
            state = .initials(initials)
        }
    }
    
    private func getInitials(for name: String) -> String {
        name.split(separator: " ")
            .compactMap { $0.first?.uppercased() }
            .joined()
    }
    
}

