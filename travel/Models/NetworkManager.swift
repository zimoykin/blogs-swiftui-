
import Foundation
import Combine

struct NetworkManager {
    
    //MARK: - POST METHOD
    public static func post <T: Codable>
    (to address: String, login: String? = nil, password: String? = nil, token: String? = nil, body: Data? = nil) -> Future<T, Error> {
        return Future { promise in
            
            guard let url = URL(string: address) else {
                promise(.failure(NetworkError(description: "url error") ) )
                return
            }
            
            var req: URLRequest = URLRequest(url: url)
            req.httpMethod = "POST"
            req.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            //MARK: - AUTHORIZATION BASIC
            if let login = login, let password = password {
                let loginString = String(format: "%@:%@", login, password)
                let loginData = loginString.data(using: String.Encoding.utf8)!
                let base64LoginString = loginData.base64EncodedString()
                req.addValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            } else if let token = token {
                req.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            //MARK: - BODY
            req.httpBody = body

            URLSession.shared.dataTask(with: req) { data, response, error in
                
                if let error = error {
                    promise( .failure(error) )
                }
                
                if let response = response as? HTTPURLResponse,
                   response.statusCode != 200 {
                    promise(.failure( NetworkError (code: response.statusCode, description: "\(response.description)") ) )
                }
                
                if let data = data {
                    guard let decodedData = try? JSONDecoder().decode(T.self, from: data)
                    else {
                        promise(.failure( NetworkError(description: "error")) )
                        return
                    }
                    
                    return promise(.success(decodedData))
                }
                
            }
            .resume()
        }
        
    }
    
    //MARK: - GET METHOD
    static func get <T: Codable> (to address: String, params: [NetworkQuery] = [NetworkQuery](), user: User) -> Future<T, Error> {
        
        return Future { promise in
            
            var addiction = ""
            if params.count > 0 {
                addiction += "?"
                _ = params.map { query in
                    addiction += "\(query.field)=\(query.value)&"
                }
            }
            
            guard let url = URL(string: address + addiction) else {
                promise(.failure(NetworkError(description: "url error") ) )
                return
            }
            
            var req: URLRequest = URLRequest(url: url)
            req.httpMethod = "GET"
            
            req.addValue("application/json", forHTTPHeaderField: "Content-Type")
            req.addValue("Bearer \(user.accessToken)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: req) { data, response, error in
                
                if let error = error {
                    promise( .failure(error) )
                }
                
                if let response = response as? HTTPURLResponse {
                    if response.statusCode != 200 {
                        promise(.failure(NetworkError(code: response.statusCode, description: "error: \(response.description)") ) )
                    }
                }
                
                if let data = data {
                    guard let decodedData = try? JSONDecoder().decode(T.self, from: data)
                    else {
                        promise(.failure( NetworkError(description: "cant decode data from \(url.absoluteString)")) )
                        return
                    }
                    
                    return promise(.success(decodedData))
                }
                
            }
            .resume()
        }
        
    }
    
}


struct NetworkError: Error {
    var code: Int?
    var description: String
}

struct NetworkQuery: Codable {
    var field: String
    var value: String
}
