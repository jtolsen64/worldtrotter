/* Author: Jayden Olsen
   Date: 2/16/17
   Class: CSC-2310
 
   Comment: This view controller handles the map functions for World Trotter. It
            uses the MKMapView and MKMapViewDelegate to show the user his/her location,
            and to zoom in on a cycle of three preset pins. Also shows sattelite and hybrid views.
 */


import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate,
    CLLocationManagerDelegate {
    
    var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var lastLoc: CLLocationCoordinate2D!
    var lastSpan: MKCoordinateSpan!
    var pins: [MKPointAnnotation]=[]
    var currentPin = 3
    
    override func loadView() {
        // Create a map view
        mapView = MKMapView()
        mapView.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        //Set it as the view of this view controller
        view = mapView
        
        makePins()
        
        //make segmented control
        let standardString = NSLocalizedString("Standard", comment: "Standard Map View")
        let satelliteString = NSLocalizedString("Satellite", comment: "Satellite Map View")
        let hybridString = NSLocalizedString("Hybrid", comment: "Hybrid Map View")
        let segmentedControl = UISegmentedControl(items: [standardString, hybridString, satelliteString])
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
        let myLocButton = UIButton.init(type: .system)
        initButton(myLocButton)
        
        myLocButton.addTarget(self,
                         action: #selector(MapViewController.showMyLocation),
                         for: .touchUpInside)
        
        myLocButton.setTitle("My Location", for: .normal)
        
        let lbtrailingConstraint = myLocButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        lbtrailingConstraint.isActive = true
        
        //make pins button
        let pinButton = UIButton.init(type: .system)
        initButton(pinButton)
        
        pinButton.addTarget(self,
                              action: #selector(MapViewController.cyclePins),
                              for: .touchUpInside)
        
        pinButton.setTitle("Pins", for: .normal)
        
        let pbLeadingConstraint = pinButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        pbLeadingConstraint.isActive = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapViewController loaded its view.")
    }
    
    /*initButton sets up buttons. I tried to keep the buttons
      as similar as possible so this one button can make both.
      additional properties are created separately.
    */
    func initButton(_ Button: UIButton)
    {
        Button.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        Button.layer.cornerRadius = 5
        Button.layer.borderWidth = 1
        Button.layer.borderColor = UIColor.blue.cgColor
        Button.setTitleColor(UIColor.blue, for: UIControlState.normal)
        Button.setTitleColor(UIColor.white, for: UIControlState.highlighted)
        Button.showsTouchWhenHighlighted = true
    
        Button.translatesAutoresizingMaskIntoConstraints=false
        view.addSubview(Button)
        
        let topConstraint = Button.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                                  constant: -80)
        topConstraint.isActive = true
    }
    
    //changes the map view according to the button pushed on the
    //segment controller.
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
    
    /* showMyLocation sets showUserLocation to true, or false if 
        showUserLocation is already true. The rest of the process
        for zooming on the user's location is handled by the delegate
        functions.
    */
    func showMyLocation()
    {
        print("My Location Button Pressed")
        if(!self.mapView.showsUserLocation){
            self.mapView.showsUserLocation = true
        } else {
            self.mapView.showsUserLocation = false
        }
    }
    
    /* cyclePins cycles through the preset pins, showing the 
       current pin, and hiding the previous pin. On the third tap, 
       the user is brought back to where he/she was previously on 
       the map.
    */
    func cyclePins()
    {
        print("Pin Button Pressed")
        
        //check if current map center can be recorded
        if(currentPin == 3 && !self.mapView.showsUserLocation){
                lastLoc = self.mapView.centerCoordinate
                lastSpan = self.mapView.region.span
        }
        
        //stop showing user location
        self.mapView.showsUserLocation = false
        
        //increment pin
        currentPin = (currentPin+1)%4
        if(!(currentPin==0)){
            mapView.removeAnnotation(pins[currentPin-1])
        }
        if(!(currentPin==3)){
            mapView.addAnnotation(pins[currentPin])
            let span=MKCoordinateSpanMake(1,1)
            let region=MKCoordinateRegionMake(pins[currentPin].coordinate, span)
            mapView.setRegion(region, animated: true)
        }
        
        //when pins have been cycled through, return to previous map center and zoom.
        if(currentPin==3){
            let span=MKCoordinateSpanMake(lastSpan.latitudeDelta,lastSpan.longitudeDelta)
            let region=MKCoordinateRegionMake(lastLoc, span)
            mapView.setRegion(region, animated: true)
        }
   }
    
    //creates the three preset pins
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
        let coord3 = CLLocationCoordinate2D(latitude: 45.84917, longitude: -84.61889)
        pin3.coordinate = coord3
        pins.append(pin3)
        
    }
    
    // Shows the user's location zoomed in. Is called by mapViewWillStartLocatingUser
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation)
    {
        let span=MKCoordinateSpanMake(1,1)
        let region=MKCoordinateRegionMake(userLocation.coordinate,span)
        mapView.setRegion(region, animated: true)
    }
    
    
    /* mapViewWillStartLocatingUser activates When showUserLocation is true,
       and in this case, it checks whether it can record the current map center,
       and if not, it removes any pins on the map. Also, sets mapView to show the
       user location.
    */
    func mapViewWillStartLocatingUser(_ mapView: MKMapView)
    {
        print("Start loading")
        if(currentPin==3){
            lastLoc = self.mapView.centerCoordinate
            lastSpan = self.mapView.region.span
        }
        else{
            mapView.removeAnnotation(pins[currentPin])
        }
    }
    
    /*mapViewWillStartLocatingUser activates When showUserLocation is false,
      and it results in the map returning to the last location the user was at
      on the map, before my location and pin buttons were pushed.
    */
    func mapViewDidStopLocatingUser(_ mapView: MKMapView)
    {
        print("Stop loading")
        let span=MKCoordinateSpanMake(lastSpan.latitudeDelta,lastSpan.longitudeDelta)
        let region=MKCoordinateRegionMake(lastLoc, span)
        mapView.setRegion(region, animated: true)
    }
}



