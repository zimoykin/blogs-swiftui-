//
//  BlogModel.swift
//  travel
//
//  Created by Дмитрий on 18.01.2021.
//

import Foundation
import Combine
import SwiftUI


class BlogModel: ObservableObject {
    
    @Published var blogContent: BlogContent?
    var current_image: String?
    var images = [String:UIImage]()
    var id: UUID

    init (_ id: UUID) {
        self.id = id
    }

    var cancellables = [AnyCancellable]()

    func getBlog (user: User) {

        let futureBlogs: Future <BlogContent, Error> = NetworkManager.get(to: "\(K.server)api/blogs/id", params: [NetworkQuery(field: "blogid", value: self.id.uuidString)], user: user)
        futureBlogs.sink { err in
            debugPrint(err)
        } receiveValue: { blog in
            DispatchQueue.main.async {
                self.blogContent = blog
                self.current_image = blog.image
            }
        }.store(in: &cancellables)
        
        getAllImages(user: user)
        
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
          
            for image in images {
                URLSession.shared.dataTask(with: URL(string: image)!) { data, response, error in
                    guard let data = data else { return }
                    DispatchQueue.main.async {
                        self.images[image] = UIImage(data: data)
                    }
                }.resume()
            }
            
        }.store(in: &cancellables)

    }
    
}

struct BlogContent: Codable {
    var title: String
    var description: String
    var id: UUID
    var image: String
    var tags: [String]
}
struct BlogInput: Codable {
    var title: String
    var description: String
    var placeId: UUID
    var tags: String
    
    init (title: String, description: String, tags: String, place: PlaceModel) {
        
        self.title = title
        self.description = description
        self.placeId = place.id
        self.tags = tags
    }
    
    func toData() throws -> Data? {
        try JSONEncoder().encode(self)
    }
}

class BlogList: ObservableObject {
    
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
    
    func saveBlog (
        user: User,
        blog: BlogInput,
        completion: @escaping (BlogContent) -> () ) {
     
        let blog: Future <BlogContent, Error> = NetworkManager.post(to: "\(K.server)api/blogs/", token: user.accessToken, body: try? blog.toData()!)
        blog.sink { (result) in
            switch result {
            case .failure(let error):
                print (error)
            case .finished:
                print ("saveBlog success")
            }
        } receiveValue: { (blog) in
            self.getPage(user: user)
            completion(blog)
        }.store(in: &cancellables)

        
        
    }
}

//
//this.httpClient.post<BlogModel>(`${K.server}api/blogs/`, JSON.stringify({
//       title: title, description: description, placeId: this.placeid, tags: tags
//     }), { headers: headers })
