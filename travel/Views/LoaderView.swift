//
//  LoaderView.swift
//  travel
//
//  Created by Дмитрий on 18.01.2021.
//

import SwiftUI

struct LoaderView: View {
    
    @State private var isLoading = false
    @State private var heartSizeChanged = false
    
    var body: some View {
    
        ZStack {
            Circle()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                .foregroundColor(Color(.systemGray5))

            Image(systemName: "heart.fill")
                .foregroundColor(.white)
                .font(.system(size: 200))
                .animation(nil)
                .scaleEffect(heartSizeChanged ? 1.0 : 0.5)
                .opacity(heartSizeChanged ? 1.0 : 0)
                .animation(.spring(response: 0.3, dampingFraction: 0.3, blendDuration: 0.3))
        }
        .onAppear {
            toggleSize()
        }
 
    }
    
    private func toggleSize () {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.heartSizeChanged.toggle()
            toggleSize()
        }
    }
}

struct LoaderView_Previews: PreviewProvider {
    static var previews: some View {
        Image(systemName: "heart.fill")
        
    }
}
