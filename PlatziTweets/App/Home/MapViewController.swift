//
//  MapViewController.swift
//  PlatziTweets
//
//  Created by TACODE on 16/06/20.
//  Copyright © 2020 Ivan Quintana. All rights reserved.
//

import Foundation
import MapKit

class MapViewController: UIViewController {
    
    var posts = [Post]()
    
    let mapView: MKMapView = {
        let view = MKMapView()
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
        navigationItem.title = "Map"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupMarkers()
    }
    
    private func setupMarkers() {
        posts.forEach { (post) in
            let marker = MKPointAnnotation()
            marker.coordinate = CLLocationCoordinate2D(latitude: post.location.latitude,
                                                       longitude: post.location.longitude)
            
            marker.title = post.text
            marker.subtitle = post.author.names
            
            mapView.addAnnotation(marker)
        }
        
        guard let lastPost = posts.last else {
            return
        }
        
        let lastPostLocation = CLLocationCoordinate2D(latitude: lastPost.location.latitude,
                                                      longitude: lastPost.location.longitude)
        
        guard let heading = CLLocationDirection(exactly: 12) else {
            return
        }
        
        mapView.camera = MKMapCamera(lookingAtCenter: lastPostLocation, fromDistance: 30, pitch: .zero, heading: heading)
        
    }
    
    func setupViews() {
        view.addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
    }
}
