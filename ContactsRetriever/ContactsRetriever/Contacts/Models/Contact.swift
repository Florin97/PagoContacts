//
//  Contact.swift
//  ContactsRetriever
//
//  Created by Florin Velesca on 09.02.2024.
//

import Foundation

enum Status: String, Codable {
    case active = "active"
    case inactive = "inactive"
}

enum Gender: String, Codable {
    case male = "male"
    case female = "female"
}

struct Contact: Codable, Identifiable {
    let id: Int
    let name: String
    let email: String
    let gender: Gender
    let status: Status
}
