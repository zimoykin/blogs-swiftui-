//
//  PlaceModel.swift
//  travel
//
//  Created by Дмитрий on 23.01.2021.
//

import Foundation
import Combine

struct PlaceModel: Codable {
   var id: UUID
   var title: String
   var description: String
   var country: CountryModel
   var image: [String]?
}

struct CountryModel: Codable {
   var id: UUID
   var title: String?
   var description: String?
}


class Place: ObservableObject {
    
     @Published var selected: PlaceModel?
     private var cancellables = [AnyCancellable]()
    
    
    func getPlace (_ country: CountryModel, _ user: User, completion: @escaping ([PlaceModel]) -> Void) {
        
        let place:Future<[PlaceModel], Error> = NetworkManager.get(to: "\(K.server)api/places/search",
                                                                   params: [NetworkQuery(field: "field",
                                                                                         value: "country_id"),
                                                                            NetworkQuery(field: "value",
                                                                                         value: "\(country.id.uuidString)")],
                                                                   user: user)
        place.sink { (completion) in
            switch completion {
            case .failure(let error):
                debugPrint(error)
            case .finished:
                debugPrint("done")
            }
        } receiveValue: { val in
            completion(val)
        }.store(in: &cancellables)

        
    }
    
}



class Country: ObservableObject {
    
    private var cancellables = [AnyCancellable]()
    @Published var selected: CountryModel?
    
    func getCountryList (user: User, completion: @escaping ([CountryModel]) -> Void) {
        
        let country:Future<[CountryModel], Error> = NetworkManager.get(to: "\(K.server)api/countries/list",
                                                                   params: [NetworkQuery](), user: user)
        country.sink { result in
                
            switch result{
            case .failure(let error):
                print ("getCountryList \(error)")
            case .finished:
                print ("getCountryList success")
            }
            
            
            } receiveValue: { list in
                completion (list)
            }.store(in: &cancellables)

        
        
    }
}



//[{"title":"Italy",
//    "description":"",
//    "id":"9CFF8546-FA29-4A18-90EF-452070B7A37C"},
// {"title":"Turkey",
//    "description":"",
//    "id":"5D137C2B-BC41-40BD-9515-628A2A53C1AC"},
// {"title":"USA ",
//    "description":"",
//    "id":"523FAE8C-5A75-4D54-A9C1-A91D164AEA23"}]

//[{"title":"California ",
//    "id":"ABC11EBE-4622-49AF-8BAC-0F4BD5D9562E",
//    "country":{"id":"523FAE8C-5A75-4D54-A9C1-A91D164AEA23"},
//    "description":""}]
