//
//  URLImage.swift
//  travel
//
//  Created by Дмитрий on 18.01.2021.
//

import SwiftUI
import Combine

struct URLImage: View {
    
    @ObservedObject var imageLoader: ImageLoader
    @ObservedObject var blog: BlogModel
    @State var image: UIImage = UIImage()
    @State var images: [String] = [String]()
    @State var isLoading: Bool = false
    
    var user: UserModel
    
    init(imageURL: String, _ blog: BlogModel, user: UserModel) {
        imageLoader = ImageLoader(urlString: imageURL)
        self.blog = blog
        self.user = user
    }
    
    var body: some View {
        
        if blog.images == nil && isLoading {
            VStack(alignment: .center, spacing: 0) {
                LoaderView()
            }
        } else {
            
            Button(action: {
             
                if blog.images == nil {
                    isLoading = true
                    blog.getAllImages (user: user.getUser()!)
                } else {
                    
                }
                
            }) {
               Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:getScreenWidth(), alignment: .center)
                    .onReceive(imageLoader.didChange) { data in
                        self.image = UIImage(data: data) ?? UIImage()
                    }.edgesIgnoringSafeArea(.all)
                    .clipped()
                .onReceive(blog.$images) { imagePath in
                    print (imagePath)
                }
                
            }
        }
    }
    
    
    func getScreenWidth () -> CGFloat {
        UIScreen.main.bounds.width
    }

}
