//
//  ContactsViewModelTests.swift
//  ContactsRetrieverTests
//
//  Created by Florin Velesca on 10.02.2024.
//

import XCTest
@testable import ContactsRetriever

class MockContactsService: ContactsServiceProtocol {
    var error: Error?
    var contacts: [Contact]?
    var waitTIme: UInt64 = 0
    
    func fetchContacts() async throws -> [ContactsRetriever.Contact] {
        try await Task.sleep(nanoseconds: waitTIme * 1000000000)
        return contacts ?? []
    }
}

class MockContactsCache: ContactsCacheServiceProtocol {
    var contacts: [Contact]?
    
    func cacheContacts(_ contacts: [ContactsRetriever.Contact]) {
        self.contacts = contacts
    }
    
    func loadCachedContacts() -> [ContactsRetriever.Contact]? {
        return contacts
    }
    
    
}


class ContactsViewModelTests: XCTestCase {
    
    func testFetchContactSuccess()  async {
        let mockCacheService = MockContactsCache()
        let mockService = MockContactsService()
        mockService.contacts = [Contact(id: 1, name: "First Name", email: "email@email.com", gender: .male, status: .active)]
        let viewModel = ContactsViewModel(contactsService: mockService, contactsCacheService: mockCacheService)
        
        await viewModel.fetchContacts()
        
        switch viewModel.state {
        case .loaded(let contacts):
            XCTAssertEqual(contacts.count, 1, "Should have loaded one contact")
        default:
            XCTFail("Expected the loaded state, got \(viewModel.state)")
            
        }
    }
    
    func testFechOnlyActiveContacts() async {
        let mockService = MockContactsService()
        let mockCacheService = MockContactsCache()
        mockService.contacts = [
            Contact(id: 1, name: "First Name", email: "email@email.com", gender: .male, status: .active),
            Contact(id: 2, name: "First Name", email: "email@email.com", gender: .male, status: .inactive),
            Contact(id: 3, name: "First Name", email: "email@email.com", gender: .male, status: .active),
            Contact(id: 4, name: "First Name", email: "email@email.com", gender: .male, status: .inactive),
            Contact(id: 5, name: "First Name", email: "email@email.com", gender: .male, status: .inactive)
        ]
        let viewModel = ContactsViewModel(contactsService: mockService, contactsCacheService: mockCacheService)
        
        await viewModel.fetchContacts()
        
        switch viewModel.state {
        case .loaded(let contacts):
            XCTAssertEqual(contacts.count, 2, "Should have only fetch the active contacts (2)")
        default:
            XCTFail("Expected the loaded state, got \(viewModel.state)")
            
        }
    }
    
    func testViewModelStates() async {
        let mockService = MockContactsService()
        let mockCacheService = MockContactsCache()
        mockService.contacts = [Contact(id: 1, name: "First Name", email: "email@email.com", gender: .male, status: .active)]
        mockService.waitTIme = 2
        let viewModel = ContactsViewModel(contactsService: mockService, contactsCacheService: mockCacheService)
        
        let expectation = XCTestExpectation(description: "Fetch Contact")
        
        guard case .idle = viewModel.state else {
            return XCTFail("The state Should be idle")
        }
        
        await viewModel.fetchContacts()
        expectation.fulfill()
        
        await fulfillment(of: [expectation], timeout: 4)
        
        guard case .loaded(_) = viewModel.state else {
            return XCTFail("The State should be loaded after completion")
        }
    }
    
    func testContactsLoadedFromCache() async {
        let mockService = MockContactsService()
        let mockCacheService = MockContactsCache()
        mockService.contacts = [Contact(id: 1, name: "Service Contact", email: "email@email.com", gender: .male, status: .active)]
        mockCacheService.contacts = [Contact(id: 1, name: "Cached Contact", email: "email@email.com", gender: .male, status: .active)]
        let viewModel = ContactsViewModel(contactsService: mockService, contactsCacheService: mockCacheService)
        
        await viewModel.fetchContacts()
        
        switch viewModel.state {
        case .loaded(let contacts):
            XCTAssertTrue(contacts.first?.name == "Cached Contact", "The contact shoul be the cached one" )
        default:
            XCTFail("the state should be loaded")
        }
        
    }
}
