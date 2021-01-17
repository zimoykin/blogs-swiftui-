import SwiftUI
import CoreData
import Combine

struct LoginView: View {

    @State private var username: String = ""
    @State private var password: String = ""
    
    @FetchRequest(entity: UserModel.entity(), sortDescriptors: []) var users: FetchedResults<UserModel>
    
    @ObservedObject var user: UserObserver
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 10) {
            TextField("username", text: $username).fixedSize(horizontal: true, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            SecureField("password", text: $password).fixedSize(horizontal: true, vertical: true)
            Button("Login") {
                user.login(username, password)
            }.padding()
            .onAppear {
                if users.count > 0 {
                    user.logined = true
                }
            }
        }
    }
    
}
    
