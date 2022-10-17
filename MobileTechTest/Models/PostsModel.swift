//
//  PostsModel.swift
//  Zemoga
//
//  Created by victor.sanchez on 5/10/22.
//

import Foundation

class Post: Codable {
    var userId: Int
    var id: Int
    var title: String
    var body: String
    var isFavorite: Bool?
    
    init(userId: Int, id: Int, title: String, body: String, isFavorite: Bool) {
        self.userId = userId
        self.id = id
        self.title = title
        self.body = body
        self.isFavorite = isFavorite
    }
}

struct Comment: Codable {
    var postId: Int
    var id: Int
    var name: String
    var email: String
    var body: String
}

struct Author: Codable {
    var id: Int
    var name: String
    var username: String
    var email: String
    var address: AddressData
    var phone: String
    var website: String
    var company: CompanyData
}

struct AddressData: Codable {
    var street: String
    var suite: String
    var city: String
    var zipcode: String
    var geo: GeoData
}

struct GeoData: Codable {
    var lat: String
    var lng: String
}

struct CompanyData: Codable {
    var name: String
    var catchPhrase: String
    var bs: String
}
