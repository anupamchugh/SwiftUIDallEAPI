//
//  Models.swift
//  SwiftUIDallEAPI
//
//  Created by Anupam Chugh on 22/11/22.
//

import Foundation

struct DALLEResponse: Decodable {
    let created: Int
    let data: [Photo]
}

struct Photo: Decodable {
    let url: String
}
