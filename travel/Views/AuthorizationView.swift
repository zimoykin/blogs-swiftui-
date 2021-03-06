//
//  AuthorizationView.swift
//  travel
//
//  Created by Дмитрий on 21.01.2021.
//
import CoreData
import SwiftUI

struct AuthorizationView: View, ModelScreen {
    static var icon: String = "person.fill"
    
    
    var user: UserModel?
    var moc: NSManagedObjectContext
    
    var body: some View {
        VStack {
         
            if user == nil {
                LoginView(moc: moc)
            } else {
                VStack(alignment: .center, spacing: 0){
                    Text("Hello \(user!.username!)")
                    Button("logout") {
                        user?.logout(moc: moc)
                    }
                }
            }
            
        }.navigationTitle("Authorization")
    }
}

