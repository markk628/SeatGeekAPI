//
//  Event.swift
//  SeatGeekAPI
//
//  Created by Mark Kim on 2/11/21.
//

import Foundation

struct Event: Decodable {
    let title: String
    var performers: [Performers]
    let datetime_utc: String
    let venue: Venue
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
