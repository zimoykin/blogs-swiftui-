//
//  EmotionView.swift
//  travel
//
//  Created by Дмитрий on 22.01.2021.
//
import Combine
import SwiftUI

struct EmotionView: View {
    
//    this.httpClient.post<[Emotion]>(`${environment.server}api/emotions/set?blogid=${this.blogid}&emotion=${emotion}`, null, {
//           observe: 'response',
//           headers: this.auth.jwtHeader()
//       })
//
//    this.http.get<[Emotions]> ( `api/emotions`, [ new Param ('blogid', this.blogid)])
//        .then ( response => {
//          this.loaded = true
//          this.emotions$.next ( response.body )
//        })
    
    var blog: BlogModel
    var user: User
    @State var emotion: EmotionModel?
    
    var body: some View {
        Button(action: {
            print ("like click")
        }) {
            if let content = blog.blogContent {
                VStack {
                    if let emotion = emotion {
                        Image(emotion.emotion.rawValue)
                    } else {
                        Image(uiImage: #imageLiteral(resourceName: "noemotion"))
                    }
                }.onAppear {
                    getEmotion(content.id)
                }
            }
        }
    }
    
    
    private func getEmotion (_ blogid: UUID) {
    
        let futureBlogs: Future <[EmotionModel], Error> = NetworkManager.get(to: "\(K.server)api/emotions", params: [NetworkQuery(field: "blogid", value: blogid.uuidString)], user: user)
    
        futureBlogs.sink(receiveCompletion: { competition in
            switch competition {
            case .failure(let error):
                print (error)
            case .finished:
                print ("success")
            }
        }, receiveValue: { (emot) in
            emotion = emot.filter { $0.user.id == user.id }.first
        }).store(in: &blog.cancellables)
    }
    
}
