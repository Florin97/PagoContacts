//
//  ContactsService.swift
//  ContactsRetriever
//
//  Created by Florin Velesca on 09.02.2024.
//

import Foundation

enum NetworkError: Error {
    case urlError
    case serverError(String)
    case decodingError(String)
    case unknownError
}

protocol ContactsServiceProtocol {
    func fetchContacts() async throws -> [Contact]
}

class ContactsService: ContactsServiceProtocol {
    func fetchContacts() async throws -> [Contact] {
        guard let url = URL(string: "https://gorest.co.in/public/v2/users") else {
            throw NetworkError.urlError
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.serverError("Server Error")
        }
        
        let contacts = try JSONDecoder().decode([Contact].self, from: data)
        return contacts
    }
}
