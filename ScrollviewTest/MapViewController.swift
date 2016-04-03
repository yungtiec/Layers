//
//  MapViewController.swift
//  Layers
//
//  Created by Yung-Tien Chu on 11/25/15.
//  Copyright © 2015 Yung-Tien Chu. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: AWFWeatherMapViewController, AWFWeatherMapDelegate {
    
    var address: String = ""
    var city: String = ""
    var state: String = ""
    var unitIndex: Int = 0
    var lat: Double = 0
    var lng: Double = 0
   
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        let coord = CLLocationCoordinate2DMake(lat, lng)
        self.weatherMap.setMapCenterCoordinate(coord, zoomLevel: 8, animated: true)
        self.weatherMap.config.refreshInterval = 15 * AWFMinuteInterval
        weatherMap.weatherMapView.frame = self.view.bounds
        self.view.addSubview(weatherMap.weatherMapView)
        self.weatherMap.addLayerType(AWFLayerTypeFromString("radsat"))
        print(legendView)
        legendView.frame.origin.y = 64
        legendView.showsCloseIndicator = false
        legendView.alpha = 1
        self.view.addSubview(self.legendView)

        
        weatherMap.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.legendView.addLegendForLayerType(AWFLayerTypeFromString("radar"))
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let svc = segue.destinationViewController as! ViewController;
        svc.address = self.address
        svc.city = self.city
        svc.state = self.state
        svc.unitIndex = self.unitIndex
        svc.lat = self.lat
        svc.lng = self.lng
    }


 
}
