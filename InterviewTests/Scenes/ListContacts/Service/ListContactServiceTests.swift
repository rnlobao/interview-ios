import XCTest
@testable import Interview

class ListContactServiceTests: XCTestCase {
    
    var service: ListContactService!
    var mockSession: MockURLSession!

    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        service = ListContactService(session: mockSession)
    }

    override func tearDown() {
        service = nil
        mockSession = nil
        super.tearDown()
    }
    
    func testFetchContactsSuccess() {
        // Given
        mockSession.mockData = mockData
        mockSession.mockError = nil
        
        let expectation = self.expectation(description: "Occured Completion Handler")
        var fetchedContacts: [Contact]?
        var fetchedError: Error?
        
        // When
        service.fetchContacts { (contacts, error) in
            fetchedContacts = contacts
            fetchedError = error
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 1)
        XCTAssertNil(fetchedError)
        XCTAssertNotNil(fetchedContacts)
    }
    
    func testFetchContactsFailure() {
        // Given
        mockSession.mockData = nil
        mockSession.mockError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Test Error"])
        
        let expectation = self.expectation(description: "Occured Completion Handler")
        var fetchedContacts: [Contact]?
        var fetchedError: Error?
        
        // When
        service.fetchContacts { (contacts, error) in
            fetchedContacts = contacts
            fetchedError = error
            expectation.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 1)
        XCTAssertNil(fetchedContacts)
        XCTAssertNotNil(fetchedError)
    }
}


var mockData: Data? {
    """
    [{
      "id": 2,
      "name": "Beyonce",
      "photoURL": "https://api.adorable.io/avatars/285/a2.png"
    }]
    """.data(using: .utf8)
}
