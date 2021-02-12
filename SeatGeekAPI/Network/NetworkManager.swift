//
//  NetworkManager.swift
//  SeatGeekAPI
//
//  Created by Mark Kim on 2/11/21.
//

import Foundation

struct Request {
    let baseURL: String = "https://api.seatgeek.com/2/events"
    let clientId: String = "MjE1NDEwMzl8MTYxMzA5NDI4Ny40MjU4MDA2"
    
    // makes a request to SeatGeekAPI using the baseURL and clientId put together and returns the request
    // to the NetworkManager
    func makeRequest() -> URLRequest {
        let fullURL = URL(string: baseURL.appending("?client_id=\(clientId)"))!
        
        var request = URLRequest(url: fullURL)
        request.httpMethod = "GET"
        
        return request
    }
}

class NetworkManager {
    
    let urlSession = URLSession.shared
    
    // Extracting data from the request and turning it into usable data
    func getEvents(completion: @escaping (Result<[Event]>) -> ()) {
        let request = Request().makeRequest()
        urlSession.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse, let data = data {
                let result = Response.handleResponse(for: response)
                switch result {
                case .success:
                    let result = try? JSONDecoder().decode(EventList.self, from: data)
                    DispatchQueue.main.async {
                        completion(Result.success(result!.events))
                    }
                case .failure:
                    completion(Result.failure(NetworkError.decodingFailed))
                }
            }
        }.resume()
    }
}
