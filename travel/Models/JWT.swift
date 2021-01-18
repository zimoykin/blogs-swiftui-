import Foundation
import Combine

struct JWT {
    
    static func DecodeJWT <T:Decodable> (for token: String, expectedType: T.Type) throws -> T {
        
        let jwtPart = token.components(separatedBy: ".")
        
        if jwtPart.count != 3 {
            throw NetworkError(description: "cant read jwt!")
        }
        
        //let header = jwtPart[0]
        let payload = jwtPart[1]
       
        guard
            let jwtPartBase64 = Data(base64Encoded: JWTBase64String(payload))
        else { throw NetworkError (description: "cant convert string token") }
        
        guard
            let jwtPartDecoded = try? JSONDecoder().decode( T.self, from: jwtPartBase64 )
        else { throw NetworkError (description: "cant decode token data") }
        
        return jwtPartDecoded
    }
    
    static func JWTBase64String (_ jwtPart: String) -> String {
        
        var base64String = jwtPart
        
        let lenghtForDecode = Int(4 * ceil(Float(base64String.count) / 4.0))
        let addictionLeght = lenghtForDecode - base64String.count
      
        if addictionLeght > 0 {
            for _ in 1...addictionLeght {
                base64String += "="
            }
        }
        return base64String
    }
    
    static func IsTokenExpired (_ payload: JWTpayload) -> Bool {
        
        let expTokenDate = Date(timeIntervalSince1970: payload.exp)
        
        if expTokenDate < Date() {
            debugPrint ("token expired")
            UserDefaults.standard.set(nil, forKey: "accessToken")
            return true
        } else {
            return false
        }
        
    } //IsTokenExpired
}


//  "alg": "HS256",
//"typ": "JWT"

struct JWTHeader: Codable {
    var alg: String
    var typ: String
}

struct JWTpayload: Codable {
    var id: UUID
    var exp: Double
    var name: String
}

struct RefreshToken: Codable {
    var refreshToken: String
}


//{"exp":1610966000.214267,"name":"admin","id":"126A3325-48A3-40FC-AD96-34D5B32E84DA"}
