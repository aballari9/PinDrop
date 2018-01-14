//
//  ViewController.swift
//  Pin Drop
//
//  Created by Akhila Ballari on 10/24/17.
//  Copyright © 2017 Akhila Ballari. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    var pins = [Pin]()
    let pinsKey = "pins"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.delegate = self
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.addPin))
        longPressRecognizer.minimumPressDuration = 0.5
        longPressRecognizer.delaysTouchesBegan = true
        mapView.addGestureRecognizer(longPressRecognizer)
        
        self.addSavedPins()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    @objc func addPin(longGestureRecognizer: UILongPressGestureRecognizer) {
        if longGestureRecognizer.state != .ended {
            return
        }
        
        let location = longGestureRecognizer.location(in: self.mapView)
        let coordinate = self.mapView.convert(location, toCoordinateFrom: self.mapView)
        
        let alert = UIAlertController(title: "Add a new pin", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: {textField in
            textField.placeholder = "Pin Name"
        })
        alert.addTextField(configurationHandler: {textField in
            textField.placeholder = "Pin Fact"
        })
        let saveAction = UIAlertAction(title: "Save", style: .default, handler:
        {action in
            let nameTextField = alert.textFields![0]
            let factTextField = alert.textFields![1]
            let name = nameTextField.text ?? "Pin name"
            let fact = factTextField.text ?? "Pin Fact"
            let pin = Pin(name: name, fact: fact, coordinate: coordinate)
            self.saveNewPin(pin)
            self.mapView.addAnnotation(pin)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func addSavedPins() {
        if let data = UserDefaults.standard.value(forKey: pinsKey) as? Data {
            if let savedPins = try? PropertyListDecoder().decode([Pin].self, from: data) {
                self.pins = savedPins
                self.mapView.addAnnotations(self.pins)
            }
        }
    }
    
    func saveNewPin(_ pin: Pin) {
        self.pins.append(pin)
        UserDefaults.standard.set(try? PropertyListEncoder().encode(self.pins), forKey: pinsKey)
    }


}

