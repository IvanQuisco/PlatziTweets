//
//  AddPostViewController.swift
//  PlatziTweets
//
//  Created by Ivan Quintana on 09/06/20.
//  Copyright © 2020 Ivan Quintana. All rights reserved.
//

import Foundation
import UIKit
import Simple_Networking
import SVProgressHUD
import NotificationBannerSwift
import FirebaseStorage


class AddPostViewController: UIViewController {
    
    var imagePickerController: UIImagePickerController?
    
    let postTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        textView.layer.cornerRadius = 15
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
    
    let previewImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let openCameraButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Camera", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        if #available(iOS 13, *) {
            let image = UIImage(systemName: "photo")?.withRenderingMode(.alwaysOriginal)
            btn.setImage(image, for: .normal)
        }
        btn.tintColor = .green
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
        navigationItem.title = "Nuevo Tweet"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelButtonTapped))
        
    }
    
    @objc func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupViews() {
        view.addSubview(bottomImageView)
        bottomImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomImageView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        bottomImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [postTextView,previewImageView,openCameraButton,postButton])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 18
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
            
        postTextView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        postButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        openCameraButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        openCameraButton.addTarget(self, action: #selector(openCameraButtonTapped), for: .touchUpInside)
        
        postButton.addTarget(self, action: #selector(postButtonTapped), for: .touchUpInside)
        
        previewImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
//        previewImageView.isHidden = true
        previewImageView.image = UIImage(named: "loginBg")
        
    }
    
    @objc func openCameraButtonTapped() {
        imagePickerController = UIImagePickerController()
        imagePickerController?.sourceType  = .camera
        imagePickerController?.cameraFlashMode = .off
        imagePickerController?.cameraCaptureMode = .photo
        imagePickerController?.allowsEditing = true
        imagePickerController?.delegate = self
        
        guard let controller = imagePickerController else {return}
        
        self.present(controller, animated: true, completion: nil)
    }
    
    private func uploadPhotoToFirebase() {
        guard
            let image = previewImageView.image,
            let savedImageData = image.jpegData(compressionQuality: 0.1)
        else {
            NotificationBanner(title: nil, subtitle: "Error", leftView: nil, rightView: nil, style: .danger, colors: nil).show()
                return
        }
        
        SVProgressHUD.show(withStatus: "Uploading")
        
        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "image/jpg"
        
        let storage = Storage.storage()
        
        
        let imageName = UUID().uuidString
        
        let folderReference = storage.reference(withPath: "photos-tweet/\(imageName).jpg")
        
        DispatchQueue.global(qos: .background).async {
            
            SVProgressHUD.dismiss()
            
            folderReference.putData(savedImageData, metadata: metaDataConfig) { (meta: StorageMetadata?, error: Error?) in
                if let error = error  {
                    NotificationBanner(title: nil, subtitle: "error: \(error.localizedDescription)", leftView: nil, rightView: nil, style: .danger, colors: nil).show()
                    
                    return
                }
                
                folderReference.downloadURL { (url: URL?, error: Error?) in
                    
                    if let url = url {
                        print(url)
                    }
                }
            }
        }
        
        
        
        
    }
    
    @objc func postButtonTapped() {
        
        uploadPhotoToFirebase()
        
        return
        
        
        guard let text = postTextView.text, !text.isEmpty else {
            NotificationBanner(title: nil, subtitle: "Empty tweet", leftView: nil, rightView: nil, style: .danger, colors: nil).show()
            return
        }
        
        SVProgressHUD.show(withStatus: "Posting")
        
        let request = PostRequest(text: text, imageUrl: nil, videoUrl: nil, location: nil)
        
        SN.post(endpoint: Endpoints.post, model: request) { (response: SNResultWithEntity<Post, ErrorResponse>) in
            
            SVProgressHUD.dismiss()
            
            switch response {
            case .success:
                self.dismiss(animated: true) {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadData"), object: nil)
                }
            case .error(let error):
                NotificationBanner(title: nil, subtitle: "error: \(error.localizedDescription)", leftView: nil, rightView: nil, style: .danger, colors: nil).show()
            case .errorResult(let entity):
                NotificationBanner(title: nil, subtitle: entity.error, leftView: nil, rightView: nil, style: .warning, colors: nil).show()
            }
        }
        
    }
}


extension AddPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imagePickerController?.dismiss(animated: true , completion: nil)
        openCameraButton.setTitle("Change photo", for: .normal)
        
        if info.keys.contains(.originalImage) {
            self.previewImageView.isHidden = false
            self.previewImageView.image = info[.originalImage] as? UIImage
        }
    }
}
