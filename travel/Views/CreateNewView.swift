//
//  CreateNewView.swift
//  travel
//
//  Created by Дмитрий on 21.01.2021.
//

import SwiftUI

struct CreateNewView: View {
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var tags: String = ""
    @State private var place: String = ""
    @State private var country: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("title", text: $title).padding()
                }
                Section { TextField("description", text: $description).padding() }
               
                Section { TextField("tags", text: $tags).padding() }
                
                Section {
                    HStack{
                        TextField("country", text: $country).padding()
                        TextField("place", text: $place).padding()
                    }
                }
            }.navigationTitle("Create new")
        }.onTapGesture {
            print ("here")
        }
    }
    
}

struct CreateNewView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewView()
    }
}
