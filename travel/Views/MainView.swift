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
    
    var user: UserModel
    @ObservedObject var blogPage = Blog()
    var moc: NSManagedObjectContext
    @State var errorText: String = ""
    
    var body: some View {
        if let blogs = blogPage.blogs  {
            List{
                ForEach(blogs, id: \.uuidString) { result in
                    BlogView(result, user: user)
                }
            }
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
