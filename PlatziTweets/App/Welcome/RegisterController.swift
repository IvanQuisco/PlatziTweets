//
//  RegisterController.swift
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

class RegisterController: UIViewController {
    
    //MARK: UI Elements
    
    let nameTextfield: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Full name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailTextfield: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.autocapitalizationType = .none
        tf.keyboardType = .emailAddress
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let passwordTextfield: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let password2Textfield: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Confirm Password"
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let registerButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Registrar", for: .normal)
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
    
    
    //MARK: Lyfe Cycle
    
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
        navigationItem.title = "Registro"
    }
    
    func setupViews() {
        view.addSubview(bottomImageView)
        bottomImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        bottomImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        
        let stackView = UIStackView(arrangedSubviews: [nameTextfield,emailTextfield,passwordTextfield,password2Textfield,registerButton])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
            
    }
    
    
    //MARK: Targets
        
    @objc func registerButtonTapped() {
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
        
        guard let name = nameTextfield.text, !name.isEmpty else {
            NotificationBanner(title: "Error", subtitle: "Nombre invalido", leftView: nil, rightView: nil, style: .warning, colors: nil).show()
            return
        }
        
        guard let password = passwordTextfield.text, !password.isEmpty else {
            NotificationBanner(title: "Error", subtitle: "Password incorrecto", leftView: nil, rightView: nil, style: .warning, colors: nil).show()
            return
        }
        
        guard let password2 = password2Textfield.text, !password2.isEmpty, password == password2 else {
            NotificationBanner(title: "Error", subtitle: "Los passwords no coinciden", leftView: nil, rightView: nil, style: .warning, colors: nil).show()
            return
        }
        
        
        let request = RegisterRequest(email: email, password: password, names: name)
        
        DispatchQueue.main.async {
            SVProgressHUD.show(withStatus: "Registrando...")
        }
        
        SN.post(endpoint: Endpoints.register, model: request) { [weak self] (response: SNResultWithEntity<LoginResponse, ErrorResponse>) in
            
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
            
            switch response {
            case .success(let user):
                UserDefaults.standard.set(user.user.email, forKey: "currentUser")
                SimpleNetworking.setAuthenticationHeader(prefix: "", token: user.token)
                let nav = UINavigationController(rootViewController: HomeController())
                nav.modalPresentationStyle = .fullScreen
                self?.present(nav, animated: true, completion: nil)
            case .error:
                NotificationBanner(subtitle: "Unknown error", style: .danger, colors: nil).show()
            case .errorResult(let entity):
                NotificationBanner(subtitle: "Error: \(entity.error)", style: .warning, colors: nil).show()
            }
        }
    }
}
