//
//  ContactsCacheService.swift
//  ContactsRetriever
//
//  Created by Florin Velesca on 11.02.2024.
//

import Foundation

protocol ContactsCacheServiceProtocol {
    func cacheContacts(_ contacts: [Contact])
    func loadCachedContacts() -> [Contact]?
}

class ContactsCacheService: ContactsCacheServiceProtocol {
    func cacheContacts(_ contacts: [Contact]) {
        let encoder = JSONEncoder()
        if let encodedContacts = try? encoder.encode(contacts) {
            UserDefaults.standard.set(encodedContacts, forKey: "CachedContacts")
        }
    }

    func loadCachedContacts() -> [Contact]? {
        if let savedContacts = UserDefaults.standard.object(forKey: "CachedContacts") as? Data {
            let decoder = JSONDecoder()
            if let loadedContacts = try? decoder.decode([Contact].self, from: savedContacts) {
                return loadedContacts
            }
        }
        return nil
    }
}
