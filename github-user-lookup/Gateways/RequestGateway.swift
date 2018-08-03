import Foundation

protocol RequestGateway {
    static func load(username: String, onComplete: @escaping (Result) -> Void)
}
