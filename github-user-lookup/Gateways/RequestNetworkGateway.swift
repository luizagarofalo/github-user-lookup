//
//  RequestNetworkGateway.swift
//  github-user-lookup
//
//  Created by Luiza Collado Garofalo on 28/07/18.
//  Copyright © 2018 Luiza Garofalo. All rights reserved.
//

import Foundation

class RequestNetworkGateway: RequestGateway {
    static func load(username: String, onComplete: @escaping ([Repository]) -> Void) {
        guard let url = URL(string: "https://api.github.com/users/\(username)/repos") else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode([Repository].self, from: data)
                onComplete(response)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}
