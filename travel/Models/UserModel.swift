
import Combine
import Foundation
import CoreData
import SwiftUI


struct User: Codable {
    var id: UUID
    var username: String
    var accessToken: String
    var refreshToken: String
    
    init(id: UUID, username: String, accessToken: String, refreshToken: String) {
        self.id = id
        self.username = username
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}


final class UserObserver : ObservableObject {
    
    @Environment(\.managedObjectContext)
    private var moc
    private var cancellables = [AnyCancellable]()
    @Published var logined = false
    
    func authorize (_ username: String, _ password: String) -> Future<User, Error> {
        return NetworkManager.post(to: "\(K.server)api/users/login", login: username, password: password, token: nil)
    }
    
    func login (_ username: String, _ password: String) {
        
        let _ = authorize(username, password)
        .sink { err in
            print(err)
        } receiveValue: { (user) in
            
            let newUser = UserModel(context: self.moc)
            
            newUser.id = user.id
            newUser.accessToken = user.accessToken
            newUser.refreshToken = user.refreshToken
            newUser.username = user.username
            
            try? self.moc.save()
            DispatchQueue.main.async {
                self.logined = true
            }
            
            
        }.store(in: &cancellables)

    }
    
    
}
