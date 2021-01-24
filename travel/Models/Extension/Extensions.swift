//
//  Extensions.swift
//  travel
//
//  Created by Дмитрий on 17.01.2021.
//

import Foundation
import Combine
import SwiftUI

class ImageLoader: ObservableObject {
    
    var didChange = PassthroughSubject<UIImage, Never>()
    var isLoad = PassthroughSubject<Bool, Never>()
    var blog: BlogModel
    
    var data = UIImage() {
        didSet {
            didChange.send(data)
        }
    }
    
    init (imageURL:String, blog: BlogModel) {
        self.blog = blog
        getImages(imageURL)
    }

    func getImages (_ imagePath: String) {
        
        if let image = blog.images[imagePath] {
            self.data = image
            self.isLoad.send(true)
        } else {
            
            guard let url = URL(string: imagePath) else { return }
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self.data = UIImage(data: data)!
                    self.isLoad.send(true)
                    debugPrint("set " + imagePath)
                }
            }.resume()
        }
    }
}

enum TabItem: String, Hashable, CaseIterable {
    case home = "Blogs"
    case map = "Map"
    case new = "New blog"
    case auth = "Authorization"
    case contact = "Contacts"
}


protocol ModelScreen: View {
    
    static var icon: String { get set }
}


extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
