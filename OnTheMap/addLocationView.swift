//
//  addLocationView.swift
//  OnTheMap
//
//  Created by Anya Gerasimchuk on 10/17/15.
//  Copyright © 2015 Anya Gerasimchuk. All rights reserved.
//
//http://sweettutos.com/2015/04/24/swift-mapkit-tutorial-series-how-to-search-a-place-address-or-poi-in-the-map/
//
import Foundation
import UIKit
import CoreLocation
import MapKit


class addLocationView: UIViewController, UISearchBarDelegate{
    
    let locationManager = CLLocationManager()
  
    
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    var lat: Double = 0.0
    var long: Double = 0.0
    var mytitle: String = ""
    
    
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var firstName: UITextField!
    @IBOutlet var lastName: UITextField!
    @IBOutlet var urlLocation: UITextField!
    
    @IBAction func showSearchBar(sender: AnyObject) {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        presentViewController(searchController, animated: true, completion: nil)
    }
    
    @IBOutlet var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
                    self.infoLabel.text=""
    }


    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location " + error.localizedDescription)
    }
    
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        /*
//1: Once you click the keyboard search button, the app will dismiss the presented search controller you were presenting over the navigation bar. Then, the map view will look for any previously drawn annotation on the map and remove it since it will no longer be needed.
*/
        searchBar.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        
        /*
//2: the search process will be initiated asynchronously by transforming the search bar text into a natural language query, the ‘naturalLanguageQuery’ is very important in order to look up for -even an incomplete- addresses and POI (point of interests) like restaurants, Coffeehouse, etc.
*/
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            //3
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
        }
    }
    
    @IBAction func addPinAction(sender: AnyObject) {
        
       
        
        //EXCELLENT ARTICLE ABOUT OPTIONALS http://www.touch-code-magazine.com/swift-optionals-use-let/
        
        let first: String? = firstName.text
        let second: String? = lastName.text
        let url: String? = urlLocation.text
        
        if firstName.text!.isEmpty {
            print("emplye first name")
            self.infoLabel.text="Enter First Name"
            presentAlert("Enter First Name")
        } else if lastName.text!.isEmpty {
            print("last name emptry")
            self.infoLabel.text="Enter Last Name"
            presentAlert("Enter Last Name")
        } else if urlLocation.text!.isEmpty{
            print("url empty")
            self.infoLabel.text="Enter URL"
            presentAlert("Enter URL")

        }else if let lat = self.pointAnnotation?.coordinate.latitude{
            
            
            let long = self.pointAnnotation.coordinate.longitude
            let lat = self.pointAnnotation.coordinate.latitude
            
            print(long)
            print(lat)
            
            convienceModel.sharedInstance().addLocation(first!, second: second!, url: url!, lat: lat, long: long){ success, errorString in
                
                dispatch_async(dispatch_get_main_queue()){
                if success{
                    print("Added location success")
                    self.navigationController!.popViewControllerAnimated(true)
                }else{
                    print("failed hohoh")
                    self.infoLabel.text="Enter your location"
                    self.presentAlert(errorString)
                }
                }
            }

        }else{
            print("LOCATION EMPTRY")
            self.presentAlert("Enter Location")
        }
    }

    func presentAlert(messageString: String){
        
        //dispatch_async(dispatch_get_main_queue(), {
            
            //FORM AN ALERT
            var message = messageString
            
            let alertController = UIAlertController(title: "NEED INFORMATION!", message: message, preferredStyle:
                UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction (title: "ok", style: UIAlertActionStyle.Default){ action in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
                       //alertController.addAction(okAction)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))

            self.presentViewController(alertController, animated: true, completion: nil)
        //})
    }

    
}