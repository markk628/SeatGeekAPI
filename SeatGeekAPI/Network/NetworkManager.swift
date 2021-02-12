//
//  NetworkManager.swift
//  SeatGeekAPI
//
//  Created by Mark Kim on 2/11/21.
//

import Foundation

class NetworkManager {
    
    let urlSession = URLSession.shared
    
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
