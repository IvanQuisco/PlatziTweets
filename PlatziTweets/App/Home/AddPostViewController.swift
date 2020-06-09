//
//  AddPostViewController.swift
//  PlatziTweets
//
//  Created by Ivan Quintana on 09/06/20.
//  Copyright © 2020 Ivan Quintana. All rights reserved.
//

import Foundation
import UIKit

class AddPostViewController: UIViewController {
    
    let postTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        textView.layer.cornerRadius = 25
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let postButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Publicar", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .green
        btn.layer.cornerRadius = 25
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let bottomImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .gray
        let image = UIImage(named: "bottomImage")?.withRenderingMode(.alwaysOriginal)
        view.image = image
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
        setupNavigationItems()
        setupViews()
    }
    
    @objc func viewTapped() {
        view.endEditing(true)
    }
    private func setupNavigationItems() {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        }
//        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Nuevo Tweet"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelButtonTapped))
        
    }
    
    @objc func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupViews() {
        view.addSubview(postTextView)
        postTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        postTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        postTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        postTextView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        view.addSubview(postButton)
        postButton.topAnchor.constraint(equalTo: postTextView.bottomAnchor, constant: 20).isActive = true
        postButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20).isActive = true
        postButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        postButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(bottomImageView)
        bottomImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomImageView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        bottomImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
    }
}
