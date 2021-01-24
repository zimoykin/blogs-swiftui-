//
//  HomeView.swift
//  travel
//
//  Created by Дмитрий on 23.01.2021.
//

import SwiftUI
import CoreData
import Combine

struct HomeView: View, ModelScreen {
    
    static var icon: String = "house.fill"
    var parent: MainView
    
    @ObservedObject var blogPage: BlogList
    
    var moc: NSManagedObjectContext
    var user: UserModel
    
    // var proxy: ScrollViewReader
    
    var body: some View {
        
        if let blogs = blogPage.blogs {
            ScrollView(.vertical) {
            ScrollViewReader { scrollView in
                LazyVStack {
                    ForEach(blogs, id: \.uuidString) { result in
                        BlogView(result, user: user)
                    }
                }.onReceive(parent.movingTop) { data in
                    print ("moving top")
                    scrollView.scrollTo(blogs[0].uuidString)
                }.animation(.default)
            }
            }
            
        } else {
            VStack(alignment: .center, spacing: 0) {
                
                if blogPage.blogs == nil {
                    LoaderView()
                }
            }.onAppear {
                callgetBlogs()
            }
        }}
    
    
    
    private func callgetBlogs () {
        if user.isJwtOk(), let user = user.getUser() {
            blogPage.getPage(user: user)
        } else {
            //self.errorText = "token expired"
            do {
                try user.updateToken { (done) in
                    if done { callgetBlogs() }
                    else { user.logout(moc: moc) }
                }
            } catch { }
        }
    }
}



