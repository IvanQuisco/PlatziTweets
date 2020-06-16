//
//  HomeViewController.swift
//  PlatziTweets
//
//  Created by Ivan Quintana on 01/06/20.
//  Copyright © 2020 Ivan Quintana. All rights reserved.
//

import Foundation
import UIKit
import Simple_Networking
import SVProgressHUD
import NotificationBannerSwift
import AVKit

class HomeController: UITableViewController {
    
    let cellID = "cellID"
    
    var dataSource: [Post] = [] {
        didSet {
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    let newPostButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("＋", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        btn.backgroundColor = .green
        btn.layer.cornerRadius = 25
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = CGSize(width: 0, height: 3)
        btn.layer.shadowOpacity = 0.5
        btn.layer.shadowRadius = 4
        btn.layer.masksToBounds = false
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationItems()
        setupTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name("reloadData"), object: nil)
    }
    
    @objc func reloadData() {
        getPosts(loadingMessage: "Updating")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getPosts(loadingMessage: "Getting Tweets")
    }
    
    private func setupTableView() {
        tableView.register(TweetCell.self, forCellReuseIdentifier: cellID)
        
        view.addSubview(newPostButton)
        newPostButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        newPostButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        newPostButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        newPostButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        newPostButton.addTarget(self, action: #selector(newPostButtonTapped), for: .touchUpInside)
    }
    
    @objc func newPostButtonTapped() {
        let postController = AddPostViewController()
        let nav = UINavigationController(rootViewController: postController)
        self.present(nav, animated: true, completion: nil)
    }
    
    func setupNavigationItems() {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = .white
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        }
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Tweets"
    }

    func getPosts(loadingMessage: String) {
        
        DispatchQueue.main.async {
            SVProgressHUD.show(withStatus: loadingMessage)
        }
        
        SN.get(endpoint: Endpoints.getPost) { (response: SNResultWithEntity<[Post], ErrorResponse>) in
            
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
            
            switch response {
            case .success(let posts):
                self.dataSource = posts
            case .error(let error):
                print("error", error.localizedDescription)
            case .errorResult(let entity):
                print("error again", entity.error)
            }
        }
    }
    
    func deleteRowAt(indexPath: IndexPath) {
        let postID = dataSource[indexPath.row].id
        
        let endpoint = Endpoints.delete + postID
        
        SVProgressHUD.show(withStatus: "Wait")
        
        SN.delete(endpoint: endpoint) { [weak self] (response: SNResultWithEntity<GeneralResponse, ErrorResponse>) in
            
            SVProgressHUD.dismiss()
            
            switch response {
            case .success:
                self?.dataSource.remove(at: indexPath.row)
                self?.tableView.deleteRows(at: [indexPath], with: .left)
            case .error(let error):
                NotificationBanner(title: nil, subtitle: "Error: \(error.localizedDescription)", leftView: nil, rightView: nil, style: .danger, colors: nil).show()
            case .errorResult(let entity):
                NotificationBanner(title: nil, subtitle: "Error: \(entity.error)", leftView: nil, rightView: nil, style: .warning, colors: nil).show()
                
            }
        }
        
        
    }
}

extension HomeController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! TweetCell
        cell.post = dataSource[indexPath.row]
        
        cell.needsToShowVideo = { url in
            let avPlayer = AVPlayer(url: url)
            
            let playerController = AVPlayerViewController()
            playerController.player = avPlayer
            
            self.present(playerController, animated: true) {
                playerController.player?.play()
            }
            
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let post = dataSource[indexPath.row]
        
        let textViewWidth = UIScreen.main.bounds.width - 40
        let size = CGSize(width: textViewWidth, height: 1000)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        
        let estimatedFrame = NSString(string: post.text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        var height = estimatedFrame.height + 90
        
        if post.hasImage {
            height += UIScreen.main.bounds.width - 40
        }
        
        if post.hasVideo {
            height += 35
        }
        
        return height
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] (_, _) in
            self?.deleteRowAt(indexPath: indexPath)
        }
        return [deleteAction]
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let currentUser = UserDefaults.standard.value(forKey: "currentUser") as? String else {
            return false
        }
        return dataSource[indexPath.row].author.email == currentUser
    }
}
