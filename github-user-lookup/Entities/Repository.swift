//  swiftlint:disable identifier_name
import Foundation

struct Repository: Codable {
    let id: Int?
    let name: String?
    let owner: Owner?
    let htmlURL, description: String?
    let language: String?

    enum CodingKeys: String, CodingKey {
        case description, id, language, name, owner
        case htmlURL = "html_url"
    }
}

struct Owner: Codable {
    let login, avatarURL: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case login, id
        case avatarURL = "avatar_url"
    }
}
