import Foundation

class RequestNetworkGateway: RequestGateway {
    static func load(username: String, onComplete: @escaping (Result) -> Void) {
        guard let url = URL(string: "https://api.github.com/users/\(username)/repos") else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                onComplete(.failure(.networkError))
            }

            guard let data = data else { return }

            do {
                let response = try JSONDecoder().decode([Repository].self, from: data)
                onComplete(.success(response))
            } catch {
                onComplete(.failure(.userNotFound))
            }
        }
        task.resume()
    }
}
