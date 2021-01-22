//
//  BlogView.swift
//  travel
//
//  Created by Дмитрий on 18.01.2021.
//

import SwiftUI
import CoreData

struct BlogView: View {
    
    @ObservedObject var blog: BlogModel
    var user: UserModel
    
    init (_ id: UUID, user: UserModel) {
        self.blog = BlogModel(id)
        self.user = user
    }
    
    var body: some View {
        VStack(alignment: .center){
            if let content = blog.blogContent {
                ZStack{
                    Color.gray
                        .edgesIgnoringSafeArea(.all).overlay(
                    Text(content.title).foregroundColor(.white).bold()
                    ).frame(width: getBlogSize(), height: 40, alignment: .center)
                }
                URLImage(imageURL: content.image, blog, user: user)
                Text(content.description.prefix(200))
                    .fontWeight(.ultraLight)
                    .italic()
                    .padding(30)
                HStack{
                    AuthorView_Tags(blog: blog, user: user.getUser()!)
                    EmotionView(blog: blog, user: user.getUser()!)
                }
            } else {
                Text("loading")
            }
        }.listRowInsets(EdgeInsets())
        .onAppear{
            blog.getBlog(user: user.getUser()!)
        }
    }
    
    func getBlogSize () -> CGFloat {
        UIScreen.main.bounds.width
    }
    
}

