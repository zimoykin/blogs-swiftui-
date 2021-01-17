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
    
    @ObservedObject private var user = UserObserver()
    
    var body: some View {
        
        if user.logined {
            MainView()
        } else {
            LoginView(user: user)
        }
        
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
       ContentView()
    }
}
