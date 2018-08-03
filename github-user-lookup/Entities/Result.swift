import Foundation

enum Result {
    case success([Repository])
    case failure(LookupError)
}
