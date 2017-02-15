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
    var myLocButtonPushed: Bool = false
    var pins: [MKPointAnnotation]=[]
    var currentPin = 3
    // currentPin = currentPin+1 %4
    
    override func loadView() {
        // Create a map view
        mapView = MKMapView()
        mapView.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        //Set it as the view of this view controller
        view = mapView
        
        makePins()
        
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
        if(!myLocButtonPushed){
            myLocButtonPushed=true
            self.mapView.showsUserLocation = true
        } else {
            myLocButtonPushed=false
            self.mapView.showsUserLocation = false
        }
    }
    
    func cyclePins()
    {
        self.mapView.showsUserLocation = false
        if(currentPin == 3 && !myLocButtonPushed){
                lastLoc = self.mapView.centerCoordinate
                lastSpan = self.mapView.region.span
        }
        currentPin = (currentPin+1)%4
        if(!(currentPin==0)){
            mapView.removeAnnotation(pins[currentPin-1])
        }
        if(!(currentPin==3)){
            mapView.addAnnotation(pins[currentPin])
            mapView.setCenter(pins[currentPin].coordinate, animated: true)
        }
        if(currentPin==3){
            self.mapView.showsUserLocation = false
        }
   }
    
    func makePins()
    {
        //Pin 1: Born: Salt Lake City
        let pin1 = MKPointAnnotation()
        let coord1 = CLLocationCoordinate2D(latitude: 40.758701, longitude: -111.876183)
        pin1.coordinate = coord1
        pins.append(pin1)
        
        //Pin 2: Currently at: High Point
        let pin2 = MKPointAnnotation()
        let coord2 = CLLocationCoordinate2D(latitude: 35.9556923, longitude: -80.00531760000001)
        pin2.coordinate = coord2
        pins.append(pin2)
        
        //Pin 3: Interesting place: Mackinac Island
        let pin3 = MKPointAnnotation()
        let coord3 = CLLocationCoordinate2D(latitude: 45.86111, longitude: 84.63056)
        pin3.coordinate = coord3
        pins.append(pin3)
        
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation)
    {
        
    }
    
    func mapViewWillStartLocatingUser(_ mapView: MKMapView)
    {
        print("Start loading")
        if(currentPin==3){
            lastLoc = self.mapView.centerCoordinate
            lastSpan = self.mapView.region.span
        }
    }
    
    func mapViewDidStopLocatingUser(_ mapView: MKMapView)
    {
        print("Stop loading")
        mapView.setCenter(lastLoc, animated: true)
    }
}



