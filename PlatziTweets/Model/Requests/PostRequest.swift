//
//  PostRequest.swift
//  PlatziTweets
//
//  Created by Ivan Quintana on 08/06/20.
//  Copyright © 2020 Ivan Quintana. All rights reserved.
//

import Foundation

struct PostRequest: Codable {
    let text: String
    let imageUrl: String?
    let videoUrl: String
    let location: PostRequestLocation?
}
