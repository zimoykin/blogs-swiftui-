import SwiftUI
import CoreData
import Combine

struct LoginView: View {

    @State private var username: String = ""
    @State private var password: String = ""
    
    var moc: NSManagedObjectContext

    var body: some View {
        
        VStack(alignment: .center, spacing: 0) {
            TextField("username", text: $username)
                .fixedSize(horizontal: true, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            SecureField("password", text: $password)
                .fixedSize(horizontal: true, vertical: true)
            Button("Login") {
                _ = UserModel.login(username, password, moc: moc)
            }.padding()
        }
    }
    
}
    
