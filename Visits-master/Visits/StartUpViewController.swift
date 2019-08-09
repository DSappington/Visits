//
//  ViewController.swift
//  Visits
//
//  Created by Jeffrey Curtis on 3/24/19.
//  Copyright © 2019 Jeffrey Curtis. All rights reserved.
//

import UIKit
import CoreLocation

class StartUpViewController: UIViewController {
    let application = UIApplication.shared.delegate as! AppDelegate
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(true)
        let locationEnable = UserDefaults.standard.bool(forKey: "locationEnabled")
        print("user default = ")
        print (locationEnable)
        if (locationEnable){
            print("Should be showing segue")
            self.navigationItem.hidesBackButton = false;
           _ = navigationController?.popViewController(animated: true)
            
            
        }
        self.navigationItem.hidesBackButton = true;
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
      
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(locationBool), name: Notification.Name("LocationEnabled"), object: nil)
        
       
        
            
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    @objc func locationBool(_ notification:Notification) {
         _ = navigationController?.popViewController(animated: true)
        
    }
    @IBAction func startLocations(_ sender: UIButton) {
        application.locationEnabled = true;
        UserDefaults.standard.set(true, forKey: "locationEnabled")
        let locationManager = application.locationManager
        locationManager.delegate = application
        locationManager.requestAlwaysAuthorization()
        
        
       
    }
    

    
}

