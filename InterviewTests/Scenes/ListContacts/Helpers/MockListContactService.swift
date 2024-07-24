struct MockListContactService: ContactServiceProtocol {
    var fetchContactsResult: ([Contact]?, (any Error)?)?
    
    func fetchContacts(completion: @escaping ([Contact]?, (any Error)?) -> Void) {
        if let result = fetchContactsResult {
            completion(result.0, result.1)
        }
    }
}
