//
//  HTTPManager.swift
//  Movies
//
//  Created by Yair Shlomo on 18/08/2021.
//

import Foundation

import Foundation

class HTTPManager {
    static let shared: HTTPManager = HTTPManager()

    
    enum HTTPError: Error {
        case invalidURL
        case invalidResponse(Data?, URLResponse?)
    }
    
    public func get(urlComps: URLComponents, headers: [String : String], completionBlock: @escaping (Result<Data, Error>) -> Void) {
        guard let url = urlComps.url else {
            completionBlock(.failure(HTTPError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completionBlock(.failure(error!))
                return
            }
            
            guard
                let responseData = data,
                let httpResponse = response as? HTTPURLResponse,
                200 ..< 300 ~= httpResponse.statusCode else {
                    completionBlock(.failure(HTTPError.invalidResponse(data, response)))
                    return
            }
            
            completionBlock(.success(responseData))
        }
        task.resume()
    }
}

