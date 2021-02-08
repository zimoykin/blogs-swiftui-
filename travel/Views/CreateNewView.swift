//
//  CreateNewView.swift
//  travel
//
//  Created by Дмитрий on 21.01.2021.
//

import SwiftUI

struct CreateNewView: View, ModelScreen{

    static var icon: String = "plus.circle.fill"
    
    @State var isShowPicker = false
    @State var loading = true
    @State var image: Image? = Image("placeholder")
    
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
                        if !loading {
                            Menu {
                                ForEach(countries, id: \.id.uuidString) { result in
                                    Button("\(result.title ?? "error")") {
                                        country.selected = result
                                        place.selected = nil
                                        loading = true
                                        place.getPlace(result, user.getUser()!) { list in
                                            places = list
                                            loading = false
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
                }
                
                Section {
                    
                    Button(action: {
                        self.isShowPicker.toggle()
                    }, label: {
                        HStack(alignment: .center) {
                            Image(systemName: "camera.fill")
                            Text("Upload")
                        }
                    }).foregroundColor(Color.black).padding()
                    
                }
                image?.resizable().aspectRatio(contentMode: .fill)
                Section {
                    Label("save", systemImage: "paperplane.circle.fill")
                }.onTapGesture {
                    isShowPicker.toggle()
                }
                Section {
                }.sheet(isPresented: $isShowPicker) {
                    ImagePicker(image: self.$image)
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.loading = false
            }
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



struct ImagePicker: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode)
    var presentationMode
    
    @Binding var image: Image?
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        @Binding var presentationMode: PresentationMode
        @Binding var image: Image?
        
        init(presentationMode: Binding<PresentationMode>, image: Binding<Image?>) {
            _presentationMode = presentationMode
            _image = image
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            image = Image(uiImage: uiImage)
            presentationMode.dismiss()
            
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.dismiss()
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(presentationMode: presentationMode, image: $image)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
}
