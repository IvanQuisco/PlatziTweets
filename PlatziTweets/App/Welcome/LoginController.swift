//
//  LoginController.swift
//  PlatziTweets
//
//  Created by Ivan Quintana on 01/06/20.
//  Copyright © 2020 Ivan Quintana. All rights reserved.
//

import Foundation
import UIKit
import NotificationBannerSwift
import Simple_Networking
import SVProgressHUD

class LoginController: UIViewController {
    
    //MARK: UI Elements
    
    let emailTextfield: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.autocapitalizationType = .none
        tf.keyboardType = .emailAddress
        tf.text = "test@test.com"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let passwordTextfield: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.keyboardType = .webSearch
        tf.isSecureTextEntry = true
        tf.text = "qwerty"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let loginButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Iniciar Sesion", for: .normal)
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
    
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
        setupNavigationItems()
        setupViews()
    }
    
    
    //MARK: UI Setup
    
    func setupNavigationItems() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Iniciar sesion"
    }
    
    func setupViews() {
        view.addSubview(bottomImageView)
        bottomImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomImageView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        bottomImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        
        let stackView = UIStackView(arrangedSubviews: [emailTextfield,passwordTextfield,loginButton])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
    }
    
    
    //MARK: Targets
    
    @objc func loginButtonTapped() {
        viewTapped()
        performLogin()
    }
    
    @objc func viewTapped() {
        view.endEditing(true)
    }
    
    
    //MARK: Functions
    
    func performLogin() {
        guard let email = emailTextfield.text, !email.isEmpty else {
            NotificationBanner(title: "Error", subtitle: "Email invalido", leftView: nil, rightView: nil, style: .warning, colors: nil).show()
            return
        }
        
        guard let password = passwordTextfield.text, !password.isEmpty else {
            NotificationBanner(title: "Error", subtitle: "Password incorrecto", leftView: nil, rightView: nil, style: .warning, colors: nil).show()
            return
        }
        
        DispatchQueue.main.async {
            SVProgressHUD.show(withStatus: "Wait..")
        }

        
        
        let request = LoginRequest(email: email, password: password)

        SN.post(endpoint: Endpoints.login, model: request) { (response: SNResultWithEntity<LoginResponse, ErrorResponse>) in

            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }

            switch response {
            case .success(let user):
                UserDefaults.standard.set(user.user.email, forKey: "currentUser")
                SimpleNetworking.setAuthenticationHeader(prefix: "", token: user.token)
                let nav = UINavigationController(rootViewController: HomeController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            case .error:
                NotificationBanner(subtitle: "Unknown error", style: .danger, colors: nil).show()
            case .errorResult(let entity):
                NotificationBanner(subtitle: "Error: \(entity.error)", style: .warning, colors: nil).show()
            }
        }
    }
    
}
