//
//  MainView.swift
//  travel
//
//  Created by Дмитрий on 17.01.2021.
//

import SwiftUI
import CoreData
import Combine

struct MainView: View {
    
    @ObservedObject var blogPage = Blog()
    var user: UserModel
    var moc: NSManagedObjectContext
    @State var errorText: String = ""
    var title: String = "Blog"
    
    var body: some View {
        
        TabView {
            VStack {
                
                if let blogs = blogPage.blogs {
                    VStack(alignment: .center, spacing: 0) {
                        List{
                            ForEach(blogs, id: \.uuidString) { result in
                                BlogView(result, user: user)
                            }
                        }
                    }.navigationBarTitle(Text(title))
                } else {
                    VStack(alignment: .center, spacing: 0) {
                        if errorText != "" {
                            Text("\(errorText)").italic().shadow(color: .gray, radius: 1, x: 1, y: 1)
                        } else {
                            if blogPage.blogs == nil {
                                Text("loading")
                                    .padding()
                            }
                        }
                    }.onAppear {
                        callgetBlogs()
                    }.navigationBarTitle(Text(title))
                }
            }
                 .tabItem {
                     Image(systemName: "house.fill")
                     Text("Blogs")
             }
             CreateNewView()
                 .tabItem {
                     Image(systemName: "plus.app.fill")
                     Text("New Blog")
             }
            AuthorizationView(user: user, moc: moc)
                 .tabItem {
                     Image(systemName: "person.fill")
                     Text("Authorization")
             }
            ContactsView()
                .tabItem {
                    Image(systemName:"creditcard.fill")
                    Text("Contacts")
            }
            
         }
    }
    
    private func callgetBlogs () {
        if user.isJwtOk(), let user = user.getUser() {
            blogPage.getPage(user: user)
        } else {
            self.errorText = "token expired"
            do {
                try user.updateToken().map {
                    callgetBlogs()
                }
            } catch { }
        }
    }
    
}
