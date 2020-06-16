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
import AVFoundation
import AVKit
import MobileCoreServices
import CoreLocation

enum MediaType {
    case photo
    case video
}


class AddPostViewController: UIViewController {
    
    //MARK: - Properties
    
    private var imagePickerController: UIImagePickerController?
    private var currentVideoURL: URL?
    private var locationManager: CLLocationManager?
    private var userLocation: CLLocation?
    
    
    
    //MARK: - UI Elements
    
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
    
    let videoPreviewButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Video preview", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        if #available(iOS 13, *) {
            let image = UIImage(systemName: "video")?.withRenderingMode(.alwaysTemplate)
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
        requestLocation()
    }
    
    private func requestLocation() {
        
        guard CLLocationManager.locationServicesEnabled() else { return }
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
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
        
        let stackView = UIStackView(arrangedSubviews: [postTextView,previewImageView,videoPreviewButton,openCameraButton,postButton])
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
        
        videoPreviewButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        videoPreviewButton.addTarget(self, action: #selector(videoPreviewButtonTapped), for: .touchUpInside)
        videoPreviewButton.isHidden = true
        
        postButton.addTarget(self, action: #selector(postButtonTapped), for: .touchUpInside)
        
        previewImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        previewImageView.isHidden = true
        
    }
    
    @objc func openCameraButtonTapped() {
        
        let alert = UIAlertController(title: "Camera", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Photo", style: .default, handler: { (_) in
            self.openPhotoCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Video", style: .default, handler: { (_) in
            self.openVideoCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func videoPreviewButtonTapped() {
        performVideoPreview()
    }
    
    func performVideoPreview() {
        guard let videoURL = currentVideoURL else {return}
        
        let avPlayer = AVPlayer(url: videoURL)
        let playerController = AVPlayerViewController()
        playerController.player = avPlayer
       
        self.present(playerController, animated: true) {
            playerController.player?.play()
        }
    }
    
    
    func openVideoCamera() {
        imagePickerController = UIImagePickerController()
        imagePickerController?.sourceType  = .camera
        imagePickerController?.mediaTypes = [kUTTypeMovie as String]
        imagePickerController?.cameraFlashMode = .off
        imagePickerController?.cameraCaptureMode = .video
        imagePickerController?.videoQuality = .typeMedium
        imagePickerController?.videoMaximumDuration = TimeInterval(5)
        imagePickerController?.allowsEditing = true
        imagePickerController?.delegate = self
        
        guard let controller = imagePickerController else {return}
        
        self.present(controller, animated: true, completion: nil)
    }
    
    func openPhotoCamera() {
        imagePickerController = UIImagePickerController()
        imagePickerController?.sourceType  = .camera
        imagePickerController?.cameraFlashMode = .off
        imagePickerController?.cameraCaptureMode = .photo
        imagePickerController?.allowsEditing = true
        imagePickerController?.delegate = self
        
        guard let controller = imagePickerController else {return}
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func postButtonTapped() {
        if currentVideoURL != nil {
            uploadMeadiaToFirebase(type: .video)
        } else if previewImageView.image != nil {
            uploadMeadiaToFirebase(type: .photo)
        } else {
            savePost(imageURL: nil, videoURL: nil)
        }
    }
    
    func uploadMeadiaToFirebase(type: MediaType) {
        var data: Data?
        var metadataConfigType: String
        var path: String
        
        let mediaName: String = UUID().uuidString
        
        if type == .photo {
            if let image = previewImageView.image {
                data = image.jpegData(compressionQuality: 0.1)
            }
            metadataConfigType = "image/jpg"
            path = "images-tweets/\(mediaName).jpg"
        } else {
            if let videoURL = currentVideoURL {
                data = try? Data(contentsOf: videoURL)
            }
            metadataConfigType = "video/MP4"
            path = "videos-tweets/\(mediaName).mp4"
        }
        
        
        guard
            let validData = data
        else {
            NotificationBanner(title: nil, subtitle: "Invalid media data", leftView: nil, rightView: nil, style: .danger, colors: nil).show()
                return
        }
        
        SVProgressHUD.show(withStatus: "Uploading")
        
        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = metadataConfigType
        
        let storage = Storage.storage()
        
        let folderReference = storage.reference(withPath: path)
        
        DispatchQueue.global(qos: .background).async {
            
            folderReference.putData(validData, metadata: metaDataConfig) { (meta: StorageMetadata?, error: Error?) in
                
                SVProgressHUD.dismiss()
                
                if let error = error  {
                    NotificationBanner(title: nil, subtitle: "error: \(error.localizedDescription)", leftView: nil, rightView: nil, style: .danger, colors: nil).show()
                    
                    return
                }
                
                folderReference.downloadURL { (url: URL?, error: Error?) in
                    
                    let downloadURL = url?.absoluteString ?? ""
                    if type == .photo {
                        self.savePost(imageURL: downloadURL, videoURL: nil)
                    } else {
                        self.savePost(imageURL: nil, videoURL: downloadURL)
                    }
                    
                }
            }
        }
    }
    
    func savePost(imageURL: String?, videoURL: String?) {
        guard let text = postTextView.text, !text.isEmpty else {
            NotificationBanner(title: nil, subtitle: "Empty tweet", leftView: nil, rightView: nil, style: .danger, colors: nil).show()
            return
        }
        
        var postLocation: PostRequestLocation?
        
        if let location = self.userLocation {
            postLocation = PostRequestLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
        
        SVProgressHUD.show(withStatus: "Posting")
        
        let request = PostRequest(text: text, imageUrl: imageURL, videoUrl: videoURL, location: postLocation)
        
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
        openCameraButton.setTitle("Change", for: .normal)
        
        if info.keys.contains(.originalImage) {
            self.previewImageView.isHidden = false
            self.previewImageView.image = info[.originalImage] as? UIImage
        }
        
        if info.keys.contains(.mediaURL), let recordedVideoURL = (info[.mediaURL] as? URL)?.absoluteURL {
            self.currentVideoURL = recordedVideoURL
            videoPreviewButton.isHidden = false
        }
    }
}

extension AddPostViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let bestLocation = locations.last else {return}
        
        self.userLocation = bestLocation
        
    }
}
