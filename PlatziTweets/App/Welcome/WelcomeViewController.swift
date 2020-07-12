//
//  WelcomeViewController.swift
//  PlatziTweets
//
//  Created by Ivan Quintana on 01/06/20.
//  Copyright © 2020 Ivan Quintana. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    //MARK: UI Elments
    
    let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .gray
        let image = UIImage(named: "loginBg")?.withRenderingMode(.alwaysOriginal)
        view.image = image
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let appLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.text = "PlatziTweets"
        label.font = UIFont.boldSystemFont(ofSize: 35)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let sloganLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "La comunidad más grande de devs iOS."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let loginButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Iniciar Sesion", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 25
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let registerButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Registro", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        setupNavigationItems()
        setupViews()
    }
    
    
    //MARK: UI Setup
    
    func setupNavigationItems() {
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
    }
    
    func setupViews() {
        view.addSubview(backgroundImageView)
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        let maskView = UIView()
        maskView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        maskView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(maskView)
        maskView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor).isActive = true
        maskView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor).isActive = true
        maskView.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor).isActive = true
        maskView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor).isActive = true
        
        
        let labelStackView = UIStackView(arrangedSubviews: [appLabel,sloganLabel])
        labelStackView.distribution = .equalSpacing
        labelStackView.axis = .vertical
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelStackView)
        labelStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        labelStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let buttonStackView = UIStackView(arrangedSubviews: [loginButton,registerButton])
        buttonStackView.distribution = .equalSpacing
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 0
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonStackView)
        buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        buttonStackView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
        
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
    }
    
    
    //MARK: Targets
    
    @objc func loginButtonTapped() {
        let loginController = LoginController()
        navigationController?.pushViewController(loginController, animated: true)
    }
    
    @objc func registerButtonTapped() {
        let registerController = RegisterController()
        navigationController?.pushViewController(registerController, animated: true)
    }


}

