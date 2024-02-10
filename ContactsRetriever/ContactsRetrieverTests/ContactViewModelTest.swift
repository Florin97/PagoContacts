//
//  ContactViewModelTest.swift
//  ContactsRetrieverTests
//
//  Created by Florin Velesca on 11.02.2024.
//

import XCTest
@testable import ContactsRetriever

class ContactServiceMock: ContactServiceProtocol {
    var image: UIImage?

    func fetchImage() async throws -> UIImage? {
        return image
    }
}

class ContactViewModelTest: XCTestCase {

    
    func testLoadImageWithOddId() async {
        let contactServiceMock = ContactServiceMock()
        contactServiceMock.image = UIImage()
        let contact = Contact(id: 1, name: "First Name", email: "test@email.com", gender: .female, status: .active)
        let viewModel = ContactViewModel(contact: contact, contactService: contactServiceMock)
        
        await viewModel.loadIcon()
        
        switch viewModel.state {
        case .image(_):
            XCTAssertTrue(true, "Image state should be set")
        default:
            XCTFail("The state should be image for odd ID, when image is available")
        }
        
    }
    
    func testLoadIconWithEvenId() async {
        let contactServiceMock = ContactServiceMock()

        let contact = Contact(id: 2, name: "First Name", email: "test@email.com", gender: .female, status: .active)
        let viewModel = ContactViewModel(contact: contact, contactService: contactServiceMock)
        
        await viewModel.loadIcon()
        
        switch viewModel.state {
        case .initials(let initials):
            XCTAssertEqual(initials, "FN", "Intitials for First Name should be FN but got \(initials)")
        default:
            XCTFail("the state should be inititals for odd ID")
        }
    }
    
    func testLoadImageWithOddIdWithoutImage() async {
        let contactServiceMock = ContactServiceMock()
        let contact = Contact(id: 1, name: "First Name", email: "test@email.com", gender: .female, status: .active)
        let viewModel = ContactViewModel(contact: contact, contactService: contactServiceMock)
        
        await viewModel.loadIcon()
        
        switch viewModel.state {
        case .initials(let initials):
            XCTAssertEqual(initials, "FN", "Intitials for First Name should be FN but got \(initials)")
        default:
            XCTFail("the state should be inititals for even ID but without image")
        }
        
    }
}
