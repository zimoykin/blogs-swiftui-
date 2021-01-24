//
//  EmotionModel.swift
//  travel
//
//  Created by Дмитрий on 22.01.2021.
//
import Foundation
import Combine
import SwiftUI

struct EmotionModel: Codable {
     var user: User.Public
     var blog_id: String
     var image: String //path
     var emotion: EmotionsType?
}

public enum EmotionsType: String, Codable, CaseIterable  {
    case like
    case dislike
    case report
}


class Emotion: ObservableObject {
    
    private var cancellables = [AnyCancellable]()
    @Published var emotions: [EmotionModel]?
    @Published var emotion: EmotionsType?
    
    var blog: BlogModel
    
    init (blog: BlogModel) {
        self.blog = blog
    }
    
    func setEmotion (emotion: String, user: User, completion: @escaping (Bool) -> Void ) {
        //    this.httpClient.post<[Emotion]>(`${environment.server}api/emotions/set?blogid=${this.blogid}&emotion=${emotion}`, null, {
        //           observe: 'response',
        //           headers: this.auth.jwtHeader()
        //       })
        //
        
        let emotionReq : Future <[EmotionModel], Error> = NetworkManager.post(to: "\(K.server)api/emotions/set?blogid=\(blog.id)&emotion=\(emotion)", token: user.accessToken)
        emotionReq.sink { (result) in
            switch result {
            case .failure(let error):
                debugPrint(error)
            case .finished:
                debugPrint("success setEmotion")
            }
        } receiveValue: { (list) in
            DispatchQueue.main.async {
                self.emotions = list
                self.emotion = self.emotions?.filter { $0.user.id == user.id }.first?.emotion
            }
        }.store(in: &cancellables)

        
    }
    
    
    func getEmotion (_ blogid: UUID, user: User) {
        
        //    this.http.get<[Emotions]> ( `api/emotions`, [ new Param ('blogid', this.blogid)])
        //        .then ( response => {
        //          this.loaded = true
        //          this.emotions$.next ( response.body )
        //        })
    
        let futureBlogs: Future <[EmotionModel], Error> = NetworkManager.get(to: "\(K.server)api/emotions",
                                                                             params: [NetworkQuery(field: "blogid", value: blogid.uuidString)],
                                                                             user: user)
    
        futureBlogs.sink(receiveCompletion: { competition in
            switch competition {
            case .failure(let error):
                print (error)
            case .finished:
                print ("success getEmotion")
            }
        }, receiveValue: { (emot) in
            DispatchQueue.main.async {
                self.emotion = emot.filter { $0.user.id == user.id }.first?.emotion
            }
        }).store(in: &cancellables)
    }
    
    
    
}
