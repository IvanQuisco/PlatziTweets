//
//  Post.swift
//  PlatziTweets
//
//  Created by Ivan Quintana on 08/06/20.
//  Copyright © 2020 Ivan Quintana. All rights reserved.
//

import Foundation

struct Post {
    let id: String
    let author: User
    let imageUrl: String
    let text: String
    let videoUrl: String
    let location: PostLocation
    let hasVideo: Bool
    let hasImage: Bool
    let hasLocation: Bool
    let createdAt: String
}
