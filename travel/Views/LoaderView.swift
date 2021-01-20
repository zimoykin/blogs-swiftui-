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
    let picture = ["heart.fill", "location.fill", "sun.min.fill", "sparkle", "sun.max.fill", "moon.fill"].randomElement()!
    let color: Color = [.white, .yellow, .black].randomElement()!
    
    var body: some View {
    
        ZStack {
            Circle().transition(.opacity)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                .foregroundColor(color)
                .scaleEffect(0.5)
                .animation(.spring(response: 0.3, dampingFraction: 0.2, blendDuration: 0.1))

            Image(systemName: picture)
                .foregroundColor(.white)
                .font(.system(size: 200))
                .animation(nil)
                .scaleEffect(heartSizeChanged ? 1.0 : 0.5)
                .opacity(heartSizeChanged ? 1.0 : 0.5)
                .animation(.spring(response: 0.3, dampingFraction: 0.2, blendDuration: 0.1))
        }.foregroundColor(color)
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
