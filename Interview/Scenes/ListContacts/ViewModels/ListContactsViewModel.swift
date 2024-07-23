import Foundation

protocol ListContactProtocol {
    func loadContacts(_ completion: @escaping ([Contact]?, Error?) -> Void)
}

class ListContactsViewModel: ListContactProtocol {
    
    private let service: ListContactService
        
    init(service: ListContactService) {
        self.service = service
    }
    
    func loadContacts(_ completion: @escaping ([Contact]?, Error?) -> Void) {
        service.fetchContacts { (contacts, error) in
            DispatchQueue.main.async {
                if let error {
                    completion(nil, error)
                    return
                }
                
                if let contacts {
                    completion(contacts, nil)
                } else {
                    completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Nenhum contato"]))
                }
            }
        }
    }
    
}
