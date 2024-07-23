import Foundation

private let apiURL = "https://run.mocky.io/v3/b5542994-159c-4d66-aa37-9cc250a8c229"

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
