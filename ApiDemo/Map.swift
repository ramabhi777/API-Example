//
//  Map.swift
//  ApiDemo
//
//  Created by Appinventiv on 19/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit
import MapKit

class Map: UIViewController,MKMapViewDelegate {

    var longitude: Float32
    var latitude: Float32
    
//    init(longitude: Float32, latitude: Float32) {
//       self.longitude = longitude
//        self.latitude = latitude
//    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @IBOutlet weak var MapView: MKMapView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        MapView.delegate = self
        let sourceLocation = CLLocationCoordinate2D(latitude: 28.621, longitude: 77.3812)
        let destinationLocation = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)

        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
        
            
        let route = response.routes[0]
            self.MapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
        
        let rect = route.polyline.boundingMapRect
        self.MapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
        
        func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.red
            renderer.lineWidth = 4.0
            
            return renderer
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

