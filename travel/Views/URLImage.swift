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
    
    @State var image: UIImage?
    @State var images: [String] = [String]()
   
    var user: UserModel
    
    init(imageURL: String, _ blog: BlogModel, user: UserModel) {
        imageLoader = ImageLoader(imageURL: imageURL)
        self.blog = blog
        self.user = user
    }
    
    var body: some View {
        
        Button(action: {
            image = nil
            changeImage()
            
        }) {
            VStack{
                
                if let image = image {
                    Image(uiImage: image).resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width:getScreenWidth(), height: getScreenWidth(), alignment: .center)
                        .edgesIgnoringSafeArea(.all)
                        .clipped()
                } else {
                    LoaderView()
                }
                
            }.onReceive( imageLoader.didChange ) { data in
                self.image = UIImage(data: data) ?? UIImage()
            }
        }
        
    }
    
    
    func getScreenWidth () -> CGFloat {
        UIScreen.main.bounds.width
    }
    
    func changeImage () {
        
        if let images = blog.images, let currentImage = blog.current_image {
            if let currentIndex = images.firstIndex(of: currentImage) {
                let newIndex = currentIndex+1 < images.count ? currentIndex+1 : 0
                imageLoader.getImages( images[newIndex] )
                blog.current_image = images[newIndex]
            }
        }
        
    }
    
}
