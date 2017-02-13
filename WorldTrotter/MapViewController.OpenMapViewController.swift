//
//  MapViewController.OpenMapViewController.swift
//  WorldTrotter
//
//  Created by Jayden Olsen on 2/7/17.
//  Copyright © 2017 Jayden Olsen. All rights reserved.
//

import UIKit
import MapKit
//import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate,
    CLLocationManagerDelegate {
    
    var mapView: MKMapView!

    
    let locationManager = CLLocationManager()
    /*locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestAlwaysAuthorization()
    locationManager.startUpdatingLocation()
    */
    
    override func loadView() {
        // Create a map view
        mapView = MKMapView()
        mapView.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        //Set it as the view of this view controller
        view = mapView
        
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite", "My Location"])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex=0
        
        segmentedControl.addTarget(self,
                                   action: #selector(MapViewController.mapTypeChanged(_:)),
                                   for: .valueChanged)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints=false
        view.addSubview(segmentedControl)
        
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor,
                                                                  constant: 8)
        
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapViewController loaded its view.")
    }
    
    
    func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
            self.mapView.showsUserLocation = false
        case 3:
            self.mapView.showsUserLocation = true
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
    
    func mapViewWillStartLocatingUser(_ mapView: MKMapView)
    {
        print("Start loading")
    }
    
    func mapViewDidStopLocatingUser(_ mapView: MKMapView)
    {
        print("Stop loading")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01,0.01)
        let mylocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(mylocation, span)
        mapView.setRegion(region, animated: true)
        self.mapView.showsUserLocation = true
        locationManager.stopUpdatingLocation()
    }
}



