//
//  EmotionView.swift
//  travel
//
//  Created by Дмитрий on 22.01.2021.
//
import Combine
import SwiftUI

struct EmotionView: View {
    
    var blog: BlogModel
    var user: UserModel
    @ObservedObject var emotion: Emotion
    
    init (blog: BlogModel, user: UserModel) {
        self.blog = blog
        self.user = user
        self.emotion = Emotion(blog: blog)
    }
    
    var body: some View {
        Button(action: {
            print ("like click")
        }) {
            if let content = blog.blogContent {
                VStack {
                    
                    Menu {
                        ForEach(["report", "dislike", "like"], id: \.self) { result in
                            Button(action: {
                                emotion.setEmotion(emotion: result, user: user.getUser()!) { (done) in
                                    print(done)
                                }
                            }) {
                                HStack {
                                    Text("\(result)").foregroundColor(Color.red).font(Font.custom("Papyrus", size: 16))
                                    Image(result)
                                }
                            }
                        }

                    } label: {
                        HStack {
                            Image("\(emotion.emotion?.rawValue ?? "noemotion")")
                            Text("").foregroundColor(Color.red).font(Font.custom("Papyrus", size: 16))
                        }
                    }.foregroundColor(Color.black)
                
                }.onAppear {
                    emotion.getEmotion(content.id, user: user.getUser()!)
                }
            }
        }
    }

}
