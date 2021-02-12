//
//  Request.swift
//  SeatGeekAPI
//
//  Created by Mark Kim on 2/11/21.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

struct Request {
    let headers = [
        "Accept": "application/json",
        "Content-Type": "application/json",
    ]
    let baseURL: String = "https://api.seatgeek.com/2/events"
    let clientId: String = "MjE1NDEwMzl8MTYxMzA5NDI4Ny40MjU4MDA2"
    
    func makeRequest() -> URLRequest {
        let fullURL = URL(string: baseURL.appending("?client_id=\(clientId)"))!
        
        var request = URLRequest(url: fullURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.allHTTPHeaderFields = headers
        
        return request
    }
}
