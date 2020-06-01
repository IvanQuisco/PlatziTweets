//
//  LoginController.swift
//  PlatziTweets
//
//  Created by Ivan Quintana on 01/06/20.
//  Copyright © 2020 Ivan Quintana. All rights reserved.
//

import Foundation
import UIKit

class LoginController: UIViewController {
    
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
        setupNavigationItems()
        setupViews()
    }
    
    func setupNavigationItems() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Iniciar sesion"
    }
    
    func setupViews() {
        view.addSubview(bottomImageView)
        bottomImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        bottomImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}
