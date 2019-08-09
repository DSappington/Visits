//
//  MainTableViewController.swift
//  Visits
//
//  Created by Jeffrey Curtis on 3/24/19.
//  Copyright © 2019 Jeffrey Curtis. All rights reserved.
//  Group 2 CMSC 495 2019 April 6
//  MainTableViewController

import UIKit
import MapKit
import Contacts
/// This is the main tableview controller
class MainTableViewController: UITableViewController {
    // MARK: - Instance Variables
    // get the app delegate
    let application = UIApplication.shared.delegate as! AppDelegate
    let refreshControler  = UIRefreshControl .init()
    //var locationTextCell = LocationTableViewCell()
    let kHeaderHeight:CGFloat = 250
    //table data
    var tableData = [UserLocation]()
    //image data for locations, uses uuid for key in a hashmap
    var userSnapShots = [UUID: UIImage]()
    
    
    // MARK: - GUI Connections and Actions
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var mapSegment: UISegmentedControl!

 
    
    @IBOutlet weak var mapView: MKMapView!
    // actions called when the map type button is selected
    @IBAction func setMapType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.mapType = MKMapType.standard
            break
        case 1:
            mapView.mapType = MKMapType.satellite
            break
        case 2:
            mapView.mapType = MKMapType.hybrid
            break
        case 3:
             mapView.mapType = MKMapType.mutedStandard
            break;
        default:
            mapView.mapType = MKMapType.mutedStandard
            
        }
       
    }
    //when the visit button chnages reload the table model and refresh
    @IBAction func vistTypeChanged(_ sender: UISegmentedControl) {
        self.reloadTableData()
        
    }
    
    @IBOutlet weak var visitTypeSegment: UISegmentedControl!
    
    //this action moves to the big map controller
    @IBAction func mapButtonPressed(_ sender: UIBarButtonItem){
        // setup storyboard to push
        let storyBoard = UIStoryboard.init(name: "MapStoryboard", bundle: nil)
        guard let viewController = storyBoard.instantiateInitialViewController() else {
            print("failed")
            return
            
        }
        if let navigator = self.navigationController{
            navigator .pushViewController(viewController, animated: true)
        }
       

    }
    
    // MARK:  - Overidden View Controller Functions
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(true)
        if (CLLocationManager.authorizationStatus()  != CLAuthorizationStatus.authorizedAlways){
            self .performSegue(withIdentifier: "showMain", sender: self)
        }
    }
    
    //when view controller loads this inits the controller
    override func viewDidLoad() {
       
        
        super.viewDidLoad()
        
        /*
         This sets up the data model for the controller
 
         */
        self.tableData = self.application.userVisits
        if (!UserDefaults.standard.bool(forKey: "locationEnabled")){
            self .performSegue(withIdentifier: "showMain", sender: self)
        }
        if let headerFrame = self.headerView{
            headerFrame.frame.size .height = 250
            self.headerView.frame = headerFrame.frame
        }
  
        mapView.mapType = MKMapType.standard
        self.mapSegment.selectedSegmentIndex = 0;
        
        // register for notifcations on Visit Updates
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(UpdatePlaceMark),
                       name: Notification.Name("VisitPlaceMark"), object: nil)
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight=200;
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension
        self.tableView.estimatedSectionHeaderHeight = 44
        
        self.clearsSelectionOnViewWillAppear = true;
        self.tableView.scrollsToTop = true;
        
        refreshControl?.backgroundColor = self.navigationController?.navigationBar.barTintColor? .withAlphaComponent(0.65)
        mapView.backgroundColor=UIColor .black
        tableView.register(UINib(nibName: "HeaderFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "headerFooterView")

        
        
        tableView .addSubview(refreshControler)
        self.updateMapSettings()
        self.refreshControl?.backgroundColor = UIColor .clear
        self.refreshControl?.tintColor = self.navigationController?.navigationBar.backgroundColor;
        
        self.refreshControler .addTarget(self, action: #selector(updateLocations), for: UIControl.Event .valueChanged)
        
        
        
        //this is becuase the refreshcontroller is behind the table background
        
        self.refreshControl?.layer.zPosition = (self.tableView.backgroundView?.layer.zPosition)! + 1;
        self.reloadTableData()

    }
    //required call back when refreshcontroller is fired
    @objc func updateLocations(){
        print("update")
        self.reloadTableData()
        refreshControler .endRefreshing()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let yPos: CGFloat = -scrollView.contentOffset.y
        
        if (yPos > 0) {
            var mapViewRect: CGRect = self.mapView.frame
            mapViewRect.origin.y = scrollView.contentOffset.y
            mapViewRect.size.height = kHeaderHeight+yPos
            self.mapView.frame = mapViewRect
        }}
    
    func updateMapSettings(){
        mapView .showsCompass = true
        mapView .showsScale = true
        mapView .showsTraffic = true
        mapView .showsBuildings = true
        mapView .showsPointsOfInterest = true
        
    }    // This is a notification posted when a new location is recieved
    // The userInfo contains a dictionary of the location data
    @objc func UpdatePlaceMark(_ notification:Notification) {
        
        self .reloadTableData()
        

    }
    //MARK: - Internal functions
    
    func reloadTableData(){
      
        self.mapView.removeAnnotations(self.mapView.annotations)
        var placemarks = [MKPlacemark]()
        if(self.visitTypeSegment.selectedSegmentIndex == 0){
            self.tableData = self.application.userVisits
        }else{
            self.tableData = self.application.userLocations
        }
        let segmentValue = self.visitTypeSegment.selectedSegmentIndex
        DispatchQueue.global().async {
            self.mapView.removeAnnotations(self.mapView.annotations)
            if(segmentValue == 1){
                
                
                for userLocation:UserLocation in self.application.userLocations{
                    if(userLocation.Latitude == nil || userLocation.Longitude == nil){
                        return;
                    }
                    let coordinate = CLLocationCoordinate2D.init(latitude: userLocation.Latitude!, longitude: userLocation.Longitude!)
                    let userdict = UserLocation.getAddressDict(location: userLocation)
                    let mapMarker = MKPlacemark.init(coordinate: coordinate, addressDictionary:userdict)
                    print("location place --->")
                    print(mapMarker)
                    placemarks.append(mapMarker)
                    
                }
            }else{
                
                for userLocation:UserLocation in self.application.userVisits{
                    if(userLocation.Latitude == nil || userLocation.Longitude == nil){
                        return;
                    }
                    let coordinate = CLLocationCoordinate2D.init(latitude: userLocation.Latitude!, longitude: userLocation.Longitude!)
                    let userdict = UserLocation.getAddressDict(location: userLocation)
                    let mapMarker = MKPlacemark.init(coordinate: coordinate, addressDictionary:userdict)
                    print("visitor place --->")
                    print(mapMarker)
                    placemarks.append(mapMarker)
                    
                }
            }
            DispatchQueue.main.async {
                self.mapView.addAnnotations(placemarks)
            }
        }
        
         self.tableView.reloadData()
       
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.tableData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
   
        // Here, we use NSFetchedResultsController
        // And we simply use the section name as title
       
        
        // Dequeue with the reuse identifier
        let cell = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerFooterView") as! HeaderFooterView
       
        return cell
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerFooterView") as! HeaderFooterView
        
        return cell
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! LocationTableViewCell
        
        let place = self.tableData[indexPath.section]
        cell.MapImage.image = UIImage.init(contentsOfFile: "default-placeholder.png")
     
       
    
       
        //let street0  = (place.Name ?? "")
        let street1  = (place.Name ?? "") + " " + (place.City ?? "")
        let street2  = (place.State ?? "") + " " + (place.CountryCode ?? "")
        let street3  = (place.Country ?? "")
        
        var stringAddress = street1 + " " + street2 + " " + street3
        if let places = place.AreasOfInterest{
            for string:String in places{
                stringAddress = stringAddress + "  \n \(string)"
            }
            
        }
        
        
        
        if (place.ArrivalTime == nil){
            cell.TopLabel.text = "\(place.Time ?? Date.distantPast)"
            cell.TextView.text = stringAddress
            if stringAddress.count < 2{
                cell.BottomLabel.text = "Latitude \(place.Latitude ?? 0.0) \n Longitude \(place.Longitude ?? 0.0)"
            }else{
                cell.BottomLabel.text = " "
    
            }
        }else{
            cell.BottomLabel.text = "\(place.ArrivalTime ?? Date.distantPast)"
            cell.TopLabel.text = "\(place.DepartureTime ?? Date.distantFuture)"
            cell.TextView.text = stringAddress
            
        }
        
        if place.UID != nil{
            if let image = self.userSnapShots[place.UID!]{
            cell.MapImage.image = image;
        }else{
            
            let options = MKMapSnapshotter.Options.init()
            options.scale = UIScreen.main.scale
            options.mapType = MKMapType.standard
            options.size = CGSize(width: 200, height: 200)
            let coor = CLLocationCoordinate2D.init(latitude: place.Latitude ?? 0.0, longitude: place.Longitude ?? 0.0)
            options.region = MKCoordinateRegion(center: coor, latitudinalMeters: 300.0, longitudinalMeters: 300.0);
            let snapshotter = MKMapSnapshotter.init(options: options)
            snapshotter .start { (snapshot, error) in
                let image = snapshot?.image
               
                cell.MapImage.image = image
                self.userSnapShots[place.UID!] = image

            }
        }
        
    }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("<><><><><><><><>")
        let storyBoard = UIStoryboard.init(name: "DetailsStoryboard", bundle: nil)
        guard let viewController  = storyBoard.instantiateInitialViewController() as! DetailTableViewController?  else {
            print("failed")
            return
            
        }
      
            viewController.locations = self.tableData[indexPath.row]
      
        
        if let navigator = self.navigationController{
            navigator .pushViewController(viewController, animated: true)
        }
        
    }

}
