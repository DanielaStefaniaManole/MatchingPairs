//
//  APIHandler.swift
//  MatchingPairsDaniela
//
//  Created by Daniela Manole on 07.09.2023.
//

import Foundation

class APIHandler {
    static func getThemes(completion: @escaping (Result<[Theme], Error>) -> ()) {
        var request = URLRequest(url: URL(string: .api)!)
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            if let data = data {
                do {
                    let themes = try JSONDecoder().decode([Theme].self, from: data)
                    completion(.success(themes))
                } catch {
                    completion(.failure(error))
                }
            }
        })
        task.resume()
    }
}
