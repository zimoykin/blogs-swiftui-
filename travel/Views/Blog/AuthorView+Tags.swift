//
//  AuthorView+Tags.swift
//  travel
//
//  Created by Дмитрий on 22.01.2021.
//

import SwiftUI

struct AuthorView_Tags: View {
    
    var blog: BlogModel
    var user: User
    
    var body: some View {
        HStack {
            ForEach(blog.blogContent!.tags, id: \.self) { result in
                Text ("#" + result).font(.system(size: 14, weight: .ultraLight, design: .rounded)).foregroundColor(Color.white)
            }
        }
        
    }
    
    
}
