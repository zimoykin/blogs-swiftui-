//
//  EmotionModel.swift
//  travel
//
//  Created by Дмитрий on 22.01.2021.
//

import Foundation

struct EmotionModel: Codable {
     var user: User.Public
     var blog_id: String
     var image: String //path
     var emotion: EmotionsType
}

public enum EmotionsType: String, Codable, CaseIterable  {
    case like
    case dislike
    case report
}

