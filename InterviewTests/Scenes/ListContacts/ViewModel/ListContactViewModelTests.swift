import XCTest
@testable import Interview

class ListContactsViewModelTests: XCTestCase {
    
    private var viewModel: ListContactsViewModel!
    private var mockService: MockListContactService!
    
    override func setUp() {
        super.setUp()
        mockService = MockListContactService()
        viewModel = ListContactsViewModel(service: mockService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
    func testLoadContactsSuccess() {
        // Given
        let contacts = [
            Contact(id: 1, name: "John Doe", photoURL: "https://picsum.photos/id/237/200/"),
            Contact(id: 2, name: "Jane Doe", photoURL: "https://picsum.photos/id/237/200/")
        ]
        
        mockService.fetchContactsResult = (contacts: contacts, error: nil)
        
        // When
        viewModel.loadContacts { contacts, error in
            // Then
            XCTAssertNil(error)
            XCTAssertNotNil(contacts)
        }
    }
    
    func testLoadContactsFailure() {
        // Given
        let expectedError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Erro de Teste"])
        mockService.fetchContactsResult = (contacts: nil, error: expectedError)
                
        // When
        viewModel.loadContacts { contacts, error in
            // Then
            XCTAssertNil(contacts)
            XCTAssertEqual(error?.localizedDescription, expectedError.localizedDescription)
        }
    }
    
    func testLoadContactsNoContacts() {
        // Given
        mockService.fetchContactsResult = (contacts: nil, error: nil)
                
        // When
        viewModel.loadContacts { contacts, error in
            // Then
            XCTAssertNil(contacts)
            XCTAssertEqual(error?.localizedDescription, "Nenhum contato")
        }        
    }
}
