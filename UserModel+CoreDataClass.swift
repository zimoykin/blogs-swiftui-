//
//  UserModel+CoreDataClass.swift
//  travel
//
//  Created by Дмитрий on 18.01.2021.
//
//

import Foundation
import CoreData
import Combine

public class UserModel: NSManagedObject {
    
    var canc = Set<AnyCancellable>()

    func getUser () -> User? {
        if let userid = self.id {
            return User(id: userid, username: self.username ?? "", accessToken: self.accessToken ?? "", refreshToken: self.refreshToken ?? "")
        } else
        { return nil }
    }
    
    func isJwtOk () -> Bool {
        if let accessToken = self.accessToken {
            guard let token = try? JWT.DecodeJWT(for: accessToken, expectedType: JWTpayload.self)
            else { return false }
            return !JWT.IsTokenExpired(token)
        } else {
            return false
        }
    }
    
    func updateToken () throws -> Future <Void, NetworkError> {
        
        let request: Future <User, Error> = NetworkManager.post(to: "\(K.server)api/users/refresh", body: try JSONEncoder().encode (RefreshToken(refreshToken: self.refreshToken!)))
        
        return Future { [self] promise in
            
            request.sink { (completion) in
                switch completion {
                case .failure(let error):
                    debugPrint(error)
                case .finished:
                    debugPrint("fineshed")
                }
        } receiveValue: { [self] userData in
                accessToken = userData.accessToken
                refreshToken = userData.refreshToken
                
            if ((try? managedObjectContext?.save()) != nil) {
                promise(.success( () ))
            } else {
                promise(.failure( NetworkError(code: 0, description: "refresh falls") ))
            }
                
            }.store(in: &canc)
        }


        
    }
}
