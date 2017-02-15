//
//  MapViewController.OpenMapViewController.swift
//  WorldTrotter
//
//  Created by Jayden Olsen on 2/7/17.
//  Copyright © 2017 Jayden Olsen. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate,
    CLLocationManagerDelegate {
    
    var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var lastLoc: CLLocationCoordinate2D!
    var lastSpan: MKCoordinateSpan!
    var pinButtonPushed: Bool = false
    var myLocButtonPushed: Bool = false
    var pins: [MKPointAnnotation]=[]
    var currentPin = 0
    
    override func loadView() {
        // Create a map view
        mapView = MKMapView()
        mapView.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        //Set it as the view of this view controller
        view = mapView
        
        //make segmented control
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex=0
        
        segmentedControl.addTarget(self,
                                   action: #selector(MapViewController.mapTypeChanged(_:)),
                                   for: .valueChanged)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints=false
        view.addSubview(segmentedControl)
        
        let scTopConstraint = segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor,
                                                                  constant: 8)
        
        let margins = view.layoutMarginsGuide
        let scLeadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let scTrailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        scTopConstraint.isActive = true
        scLeadingConstraint.isActive = true
        scTrailingConstraint.isActive = true
        
        //make my location button
        let myLocButton = UIButton()
        myLocButton.setTitle("My Location", for: .normal)
        myLocButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        myLocButton.addTarget(self,
                              action: #selector(MapViewController.showMyLocation),
                                   for: .touchUpInside)
        myLocButton.translatesAutoresizingMaskIntoConstraints=false
        view.addSubview(myLocButton)
        
        let lbTopConstraint = myLocButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                                  constant: -80)
        
        let lbTrailingConstraint = myLocButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        lbTopConstraint.isActive = true
        lbTrailingConstraint.isActive = true
        
        //make pins button
        let pinButton = UIButton()
        pinButton.setTitle("Pins", for: .normal)
        pinButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        pinButton.addTarget(self,
                            action: #selector(MapViewController.cyclePins),
                              for: .touchUpInside)
        pinButton.translatesAutoresizingMaskIntoConstraints=false
        view.addSubview(pinButton)
        
        let pbBotConstraint = pinButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                               constant: -80)
        
        let pbLeadingConstraint = pinButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        pbBotConstraint.isActive = true
        pbLeadingConstraint.isActive = true
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
        default:
            break
        }
    }
    
    func showMyLocation()
    {
        self.mapView.showsUserLocation = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func cyclePins()
    {
        lastLoc = self.mapView.centerCoordinate
        lastSpan = self.mapView.region.span
        
        //Set pins
        //Pin 1: Born: Salt Lake City
        let pin1 = MKPointAnnotation()
        let coord1 = CLLocationCoordinate2D(latitude: , longitude: )
        pin1.coordinate = coord1
        mapView.addAnnotation(pin1)
        pins.append(pin1)
        
        //Pin 2: Currently at: High Point
        let pin2 = MKPointAnnotation()
        let coord2 = CLLocationCoordinate2D(latitude: , longitude: )
        pin2.coordinate = coord2
        mapView.addAnnotation(pin2)
        pins.append(pin2)
        
        //Pin 3: Interesting place: ?
        let pin3 = MKPointAnnotation()
        let coord3 = CLLocationCoordinate2D(latitude: , longitude: )
        pin3.coordinate = coord3
        mapView.addAnnotation(pin3)
        pins.append(pin3)
        
    }
    
    
    func mapViewWillStartLocatingUser(_ mapView: MKMapView)
    {
        print("Start loading")
    }
    
    func mapViewDidStopLocatingUser(_ mapView: MKMapView)
    {
        print("Stop loading")
    }
}



