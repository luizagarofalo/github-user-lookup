//
//  Repository.swift
//  github-user-lookup
//
//  Created by Luiza Collado Garofalo on 29/07/18.
//  Copyright © 2018 Luiza Garofalo. All rights reserved.
//

import Foundation

struct Repository: Codable {
    let id: Int? // swiftlint:disable:this identifier_name
    let name: String?
    let owner: Owner?
    let htmlURL, description: String?
    let language: String?

    enum CodingKeys: String, CodingKey {
        case description, id, language, name, owner // swiftlint:disable:this identifier_name
        case htmlURL = "html_url"
    }
}

struct Owner: Codable {
    let login, avatarURL: String?
    let id: Int? // swiftlint:disable:this identifier_name

    enum CodingKeys: String, CodingKey {
        case login, id // swiftlint:disable:this identifier_name
        case avatarURL = "avatar_url"
    }
}
