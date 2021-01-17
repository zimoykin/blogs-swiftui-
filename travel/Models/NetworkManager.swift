
import Foundation
import Combine

struct NetworkManager {
    
    public static func post <T: Codable>
        (to address: String, login: String?, password: String?, token: String?) -> Future<T, Error> {
        return Future { promise in
            
            guard let url = URL(string: address) else {
                promise(.failure(NetworkError(description: "url error") ) )
                return
            }
        
            var req: URLRequest = URLRequest(url: url)
            req.httpMethod = "POST"
//            if let params = params {
//                req.httpBody = try! JSONEncoder().encode(params)
//            }
            req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
            //MARK: - AUTHORIZATION BASIC
            if let login = login, let password = password {
                let loginString = String(format: "%@:%@", login, password)
                let loginData = loginString.data(using: String.Encoding.utf8)!
                let base64LoginString = loginData.base64EncodedString()
                req.addValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            }
            
            URLSession.shared.dataTask(with: req) { data, response, error in
                
                if let error = error {
                    promise( .failure(error) )
                }
                
                if let response = response as? HTTPURLResponse,
                    response.statusCode != 200 {
                    promise(.failure( NetworkError (code: response.statusCode, description: "code isnt 200") ) )
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
    
    
    static func get <T: Codable, P: Codable> (to address: String, params: P, token: String) -> Future<T, Error> {

        return Future { promise in
            guard let url = URL(string: address) else {
                promise(.failure(NetworkError(description: "url error") ) )
                return
            }

            var req: URLRequest = URLRequest(url: url)
            req.httpMethod = "GET"

            req.addValue("application/json", forHTTPHeaderField: "Content-Type")
            req.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            URLSession.shared.dataTask(with: req) { data, response, error in

                if let error = error {
                    promise( .failure(error) )
                }

                if let response = response as? HTTPURLResponse,
                    response.statusCode != 200 {
                    promise(.failure(NetworkError(code: response.statusCode, description: "error: \(response.description)") ) )
                }

                if let data = data {
                    guard let decodedData = try? JSONDecoder().decode(T.self, from: data)
                    else { promise(.failure( NetworkError(description: "cant decode data")) )
                    return }

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
