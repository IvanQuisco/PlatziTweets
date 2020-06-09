//
//  TweetCell.swift
//  PlatziTweets
//
//  Created by Ivan Quintana on 08/06/20.
//  Copyright © 2020 Ivan Quintana. All rights reserved.
//

import Foundation
import UIKit

class TweetCell: UITableViewCell {
    
    var post: Post? {
        didSet {
            setTweet()
        }
    }
    
    
    let nameLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString()
        attributedText.append(NSAttributedString(string: "Ivan Q ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.black]))
        attributedText.append(NSAttributedString(string: "@IvanQuintana", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        label.attributedText = attributedText
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let mesageLabel: UILabel = {
        let label = UILabel()
        label.text = "This is supposed to be the displayed tweet"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tweetImageView: UIImageView = {
        let im = UIImageView()
        im.contentMode = .scaleAspectFit
        im.backgroundColor = .gray
        im.translatesAutoresizingMaskIntoConstraints = false
        return im
    }()
    
    let videoButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Ver Video", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        if #available(iOS 13.0, *) {
            let image = UIImage(systemName: "video.fill")
            btn.setImage(image, for: .normal)
        }
        btn.imageView?.tintColor = .green
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "06/08/1995"
        label.font = UIFont.boldSystemFont(ofSize: 11)
        label.textColor = .gray
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [nameLabel,mesageLabel,tweetImageView,videoButton,dateLabel])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        tweetImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    func setTweet() {
        guard let post = self.post else {
            return
        }
        let attributedText = NSMutableAttributedString()
        attributedText.append(NSAttributedString(string: post.author.names+" ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.black]))
        attributedText.append(NSAttributedString(string: post.author.nickname, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        nameLabel.attributedText = attributedText
        mesageLabel.text = post.text
        if post.hasImage {
            tweetImageView.image = UIImage(named: "loginBg")?.withRenderingMode(.alwaysOriginal)
        } else {
            tweetImageView.image = nil
        }
        if post.hasVideo {
            videoButton.setTitle("Ver Video", for: .normal)
            videoButton.setTitleColor(.black, for: .normal)
            if #available(iOS 13.0, *) {
                let image = UIImage(systemName: "video.fill")
                videoButton.setImage(image, for: .normal)
            }
        } else {
            videoButton.setImage(nil, for: .normal)
            videoButton.setTitle("Sin Video Disponible", for: .normal)
        }
        dateLabel.text = post.createdAt
    }
}
