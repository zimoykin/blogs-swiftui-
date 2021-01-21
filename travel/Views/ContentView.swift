//
//  ContentView.swift
//  travel
//
//  Created by Дмитрий on 17.01.2021.
//

import SwiftUI
import CoreData
import Combine

struct ContentView: View {

    @State private var username: String = ""
    @State private var password: String = ""
    @FetchRequest(entity: UserModel.entity(), sortDescriptors: [])
    var user: FetchedResults<UserModel>
    
    @Environment(\.managedObjectContext) private var moc
    
    var body: some View {
        if let user = user.first {
            MainView(user: user, moc: moc)
        } else {
            AuthorizationView(user: user.first, moc: moc)
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
       ContentView()
    }
}
