//
//  Repository.swift
//  github-user-lookup
//
//  Created by Luiza Collado Garofalo on 29/07/18.
//  Copyright © 2018 Luiza Garofalo. All rights reserved.
//

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
