//
//  BlogModel.swift
//  travel
//
//  Created by Дмитрий on 18.01.2021.
//

import Foundation
import Combine


class BlogModel: ObservableObject {
    
    @Published var blogContent: BlogContent?
    @Published var images: [String]?
    @Published var id: UUID

    init (_ id: UUID) {
        self.id = id
    }

    private var cancellables = [AnyCancellable]()

    func getBlog (user: User) {

        let futureBlogs: Future <BlogContent, Error> = NetworkManager.get(to: "\(K.server)api/blogs/id", params: [NetworkQuery(field: "blogid", value: self.id.uuidString)], user: user)
        futureBlogs.sink { err in
            debugPrint(err)
        } receiveValue: { blog in
            DispatchQueue.main.async {
                self.blogContent = blog
            }
        }.store(in: &cancellables)
        
    }
    
    
    func getAllImages  (user: User) {

        let imagesFuture: Future<[String],Error> = NetworkManager.get(to: "\(K.server)api/blogs/images/list", params: [NetworkQuery(field: "blogid", value: self.id.uuidString)], user: user)

        imagesFuture.sink { (completion) in

            switch completion{
            case .failure(let error):
                print (error)
            case .finished:
                print ("fin")
            }
            
        } receiveValue: { images in
            DispatchQueue.main.async {
                self.images = images
            }
        }.store(in: &cancellables)

    }
    
}

struct BlogContent: Codable {
    var title: String
    var description: String
    var id: UUID
    var image: String
}

class Blog: ObservableObject {
    
    private var cancellables = [AnyCancellable]()
    @Published var blogs: [UUID]?
    
    func getPage (user: User) {
        
        let futureBlogs: Future <Page<UUID>, Error> = NetworkManager.get(to: "\(K.server)api/blogs/list", params: [NetworkQuery](), user: user)
        
        futureBlogs.sink { completion in
            switch completion{
            case .failure(let error):
                print (error)
            case .finished:
                print ("fin")
            }
        } receiveValue: { (page) in
            DispatchQueue.main.async {
                self.blogs = page.items
            }
        }.store(in: &cancellables)

    }
    
}
