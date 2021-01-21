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
    
    static var canc = Set<AnyCancellable>()
    
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
                
            }.store(in: &UserModel.canc)
        }
        
        
        
    }
    
    static func authorize (_ username: String, _ password: String) -> Future<User, Error> {
        return NetworkManager.post(to: "\(K.server)api/users/login", login: username, password: password, token: nil)
    }
    
    static func login (_ username: String, _ password: String, moc: NSManagedObjectContext) -> Future <UserModel, Never> {
        
        return Future { promise in
            authorize(username, password).sink { err in
                print(err)
            } receiveValue: { (user) in
                
                let newUser = UserModel(context: moc)
                newUser.id = user.id
                newUser.accessToken = user.accessToken
                newUser.refreshToken = user.refreshToken
                newUser.username = user.username
                
                do {
                    try moc.save()
                    DispatchQueue.main.async {
                        promise(.success(newUser))
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }.store(in: &canc)
        }
    }
    
}
