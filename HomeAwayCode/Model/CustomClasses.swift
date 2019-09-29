//
//  CustomClasses.swift
//  HomeAwayCode
//
//  Created by Nick on 9/28/19.
//  Copyright © 2019 NickOwn. All rights reserved.
//

import Foundation

//for plist structure
struct Preferences: Codable {
    let token:String
    let apilink:String
    var savedFav:[String]
}

//for json data structure
struct JsonData: Codable {
    let events: [EventItem]
}

struct EventItem: Codable {
    let id: Int
    let title: String
    let datetime_local: String
    let performers: [Performers]
    let venue: Venue
    var is_open: Bool
}

struct Performers: Codable {
    let image: String?
    let id: Int
}

struct Venue: Codable {
    let postal_code: String
    let city: String
    let display_location: String
}
