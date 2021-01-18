//
//  Pagination.swift
//  travel
//
//  Created by Дмитрий on 18.01.2021.
//

import Foundation

struct Page<T:Codable> : Codable {
    var metadata: Metadata
    var items: [T]
}

struct Metadata: Codable {
    var page: Int
    var total: Int
    var per: Int
}

//
//
//{"metadata":{"total":6,"per":10,"page":1},"items":["97EEB2CD-0E53-4FAD-B661-1E8DAFCABC2A","285EED52-3960-4A1E-B939-1E6256E9C821","05B166BF-D324-42B3-9794-9832ACCDCC47","D8667FF0-6A6F-4C63-ADC0-2D70DBCF8F7A","C7D0F037-D23B-4F1F-9341-7814A76DA2C4","A4B4D21A-79EC-428E-A64C-718973600EC1"]}
