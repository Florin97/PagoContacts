//
//  ContactService.swift
//  ContactsRetriever
//
//  Created by Florin Velesca on 09.02.2024.
//

import Foundation
import SwiftUI

protocol ContactServiceProtocol {
    func fetchImage() async throws -> UIImage?
}

class ContactService: ContactServiceProtocol {
    func fetchImage() async throws -> UIImage? {
        guard let imageUrl = URL(string: "https://picsum.photos/200/200") else {
            return nil
        }
        let (data, _) = try await URLSession.shared.data(from: imageUrl)
        return UIImage(data: data)
    }
}
