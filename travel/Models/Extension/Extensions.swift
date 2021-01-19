//
//  Extensions.swift
//  travel
//
//  Created by Дмитрий on 17.01.2021.
//

import Foundation
import Combine

class ImageLoader: ObservableObject {
    
    var didChange = PassthroughSubject<Data, Never>()
    var isLoad = PassthroughSubject<Bool, Never>()
    
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }
    
    init (imageURL:String) {
        getImages(imageURL)
    }

    func getImages (_ imagePath: String) {
        guard let url = URL(string: imagePath) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
                self.isLoad.send(true)
                debugPrint("set " + imagePath)
            }
        }.resume()
    }
}
