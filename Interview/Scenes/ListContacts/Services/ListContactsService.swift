import Foundation

private let apiURL = "https://669ff1b9b132e2c136ffa741.mockapi.io/picpay/ios/interview/contacts"

class ListContactService {
    
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func fetchContacts(completion: @escaping ([Contact]?, Error?) -> Void) {
        guard let api = URL(string: apiURL) else {
            completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL inválida"]))
            return
        }
        
        let task = session.dataTask(with: api) { (data, response, error) in
            
            if let error {
                completion(nil, error)
                return
            }
            
            guard let jsonData = data else {
                completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Nenhum dado retornado"]))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode([Contact].self, from: jsonData)
                
                completion(decoded, nil)
            } catch let error {
                completion(nil, error)
            }
        }
        
        task.resume()
    }

}
