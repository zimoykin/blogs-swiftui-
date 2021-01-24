//
//  CreateNewView.swift
//  travel
//
//  Created by Дмитрий on 21.01.2021.
//

import SwiftUI

struct CreateNewView: View, ModelScreen{
    
    static var icon: String = "plus.circle.fill"
    
    let user: UserModel
    let blogList: BlogList
    @ObservedObject var country = Country()
    @ObservedObject var place = Place()
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var tags: String = ""
    @State private var places = [PlaceModel]()
    @State private var countries = [CountryModel]()
    
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
                        Menu {
                            ForEach(countries, id: \.id.uuidString) { result in
                                Button("\(result.title ?? "error")") {
                                    country.selected = result
                                    place.selected = nil
                                    place.getPlace(result, user.getUser()!) { list in
                                        places = list
                                    }
                                }
                            }
    
                        } label: {
                            Label( country.selected?.title ?? "country", systemImage: "location.fill")
                        }.foregroundColor(Color.black).padding()
                        //
                        Menu {
                            ForEach(places, id: \.id.uuidString) { result in
                                Button("\(result.title)") {
                                    place.selected = result
                                }
                            }
    
                        } label: {
                            Label( place.selected?.title ?? "place", systemImage: "mappin.circle")
                        }.foregroundColor(Color.black).padding()
                    }
                }
            
                Section{
     
                    Button {
                       saveBlog()
                    } label: {
                        Label("save", systemImage: "paperplane.circle.fill")
                    }

                }
            }.navigationTitle("Create new")
        }.onTapGesture {
            endEditing()
        }.onAppear{
            if countries.count == 0 {
                getCountriesList()
            }
        }
    }
    
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
    
    private func getCountriesList () {
        country.getCountryList(user: user.getUser()!) { list in
            countries = list
        }
    }
    
    private func saveBlog () {
        if title != "",
           description != "",
           place.selected != nil {
            
            blogList.saveBlog(user: user.getUser()!,
                              blog: BlogInput(title: title, description: description, tags: tags, place: place.selected!)) { (blog) in
                print (blog)
            }
            
        }
    }
    
}
