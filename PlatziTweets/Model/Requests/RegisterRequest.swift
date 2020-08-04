//
//  RegisterRequest.swift
//  PlatziTweets
//
//  Created by Ivan Quintana on 08/06/20.
//  Copyright © 2020 Ivan Quintana. All rights reserved.
//

import Foundation

struct RegisterRequest: Codable {
    let email: String
    let password: String
    let names: String
}
