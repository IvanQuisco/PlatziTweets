//
//  Endpoints.swift
//  PlatziTweets
//
//  Created by Ivan Quintana on 08/06/20.
//  Copyright © 2020 Ivan Quintana. All rights reserved.
//

import Foundation

struct Endpoints {
    static let domain = "https://platzi-tweets-backend.herokuapp.com/api/v1"
    static let login = Endpoints.domain + "/auth"
    static let register = Endpoints.domain + "/register"
    static let getPost = Endpoints.domain + "/posts"
    static let post = Endpoints.domain + "/posts"
    static let delete = Endpoints.domain + "/posts/"
}
