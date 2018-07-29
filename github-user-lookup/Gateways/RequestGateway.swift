//
//  RequestGateway.swift
//  github-user-lookup
//
//  Created by Luiza Collado Garofalo on 28/07/18.
//  Copyright © 2018 Luiza Garofalo. All rights reserved.
//

import Foundation

protocol RequestGateway {
    static func load(username: String, onComplete: @escaping ([Repository]) -> Void)
}
