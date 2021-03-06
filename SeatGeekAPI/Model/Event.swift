//
//  Event.swift
//  SeatGeekAPI
//
//  Created by Mark Kim on 2/11/21.
//

import Foundation

struct Event: Decodable {
    let short_title: String
    let performers: [Performers]
    let datetime_utc: String
    let venue: Venue
    let id: Int
}

struct Venue: Decodable {
    let city: String
    let state: String
}

struct Performers: Decodable {
    let image: String
}

struct EventList: Decodable {
    var events: [Event]
}
