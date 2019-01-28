
import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var business = Business()
    private var regionRadius = CLLocationDistance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsScale = true
        mapView.showsCompass = true
        regionRadius = 250
        
        let officeLocation = business.officeLocation
        let initialLocation = CLLocation.init(latitude: (officeLocation?.latitude.doubleValue)!, longitude: (officeLocation?.longitude.doubleValue)!)
        centerMapOnLocation(initialLocation)
        let restaurantCoordinates = CLLocationCoordinate2DMake((officeLocation?.latitude.doubleValue)!, (officeLocation?.longitude.doubleValue)!)
        let mapPin = MapPin(coordinate: restaurantCoordinates, title: (business.storeName)!, subtitle: (business.address)!)
        mapView.addAnnotation(mapPin)
        
    }
    
    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}
