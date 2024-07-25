//
//  ViewController.swift
//  ticketsReservation
//
//  Created by Victoria Samsonova on 14.05.24.
//

import UIKit
import CoreData
import CoreLocation
import MapKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, WeatherGetterDelegate {
    func didNotGetWeather(error: NSError) {
        print("Error getting weather: \(error.localizedDescription)")
    }
    
    var foundFlights = [NSManagedObject]();
    var weather : WeatherGetter!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private var locationManager = LocationManager()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        foundFlights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "flightCell", for: indexPath) as! flightCell
        let flight = foundFlights[indexPath.row]
        cell.companyLabel.text = (flight.value(forKey: "company") as! String)
        cell.durationLabel.text = (flight.value(forKey: "duration") as! String)
        cell.priceLabel.text = (flight.value(forKey: "price") as! String)
        return cell
    }
    
    func mapView(_ map: MKMapView, didSelect view: MKAnnotationView) {
        DisplayWether(city: (view.annotation?.title!)!);
    }
    
    private func DisplayWether(city:String){
        weather.getWeatherByCity(city: city);
    }
    
    func didGetWeather(weather: Weather) {
      // This method is called asynchronously, which means it won't execute in the main queue.
      // All UI code needs to execute in the main queue, which is why we're wrapping the code
      // that updates all the labels in a dispatch_async() call.
        DispatchQueue.main.async {
            var weatherInfo = "";
            let temp = round(weather.tempCelsius)
            weatherInfo += "\(Int(temp))° C \n"
            weatherInfo += weather.weatherDescription + "\n"
            let alert = UIAlertController(title:NSLocalizedString("weather", comment: ""), message: weatherInfo, preferredStyle: UIAlertController.Style.actionSheet)
            alert.preferredContentSize = self.preferredContentSize;
            alert.addAction(UIAlertAction(title: NSLocalizedString("close", comment: ""), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var fromField: UITextField!
    @IBOutlet weak var toField: UITextField!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var button: UIButton!

    
    @IBAction func findTicketsTapped(_ sender: Any) {
        let searchRequest = NSFetchRequest<Flight>(entityName: "Flight");
        searchRequest.predicate = NSPredicate(format: "cityFrom == %@ && cityTo == %@", fromField.text!, toField.text!);
        try!
        foundFlights = appDelegate.persistentContainer.viewContext.fetch(searchRequest);
        table.reloadData();
        mapView.removeAnnotations(mapView.annotations)
        locationManager.getLocation(forPlaceCalled: fromField.text!) {
            location in
            self.markLocation(title: self.fromField.text!, location: location!)
        }
        
        locationManager.getLocation(forPlaceCalled: toField.text!) {
            location in
            self.markLocation(title: self.toField.text!, location: location!)
        }
        
        
    }
    
    private func markLocation(title: String, location: CLLocation) {
        var annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = title
        mapView.addAnnotation(annotation)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        weather = WeatherGetter(delegate: self)
        table.delegate = self
        table.dataSource = self
        
        fromField.placeholder = NSLocalizedString("fromF", comment: "")
        toField.placeholder = NSLocalizedString("toF", comment: "")
        button.setTitle(NSLocalizedString("find", comment: ""), for: .normal)

        let centerCoordinate = CLLocationCoordinate2D(latitude: 53.55, longitude: 27.33) // Replace with your desired center coordinates
        let span = MKCoordinateSpan(latitudeDelta: 45.0, longitudeDelta: 45.0)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "Flight")
        let del = NSBatchDeleteRequest(fetchRequest: req)
        do {
            try appDelegate.persistentContainer.viewContext.execute(del)
        }
        catch {
            print(error)
        }
        
        UserDefaults.standard.setValue(true, forKey: "DidSetUp")
        
        var newObject = NSEntityDescription.insertNewObject(forEntityName: "Flight", into: appDelegate.persistentContainer.viewContext) as NSManagedObject;
        newObject.setValue("Emirates", forKey: "company");
        newObject.setValue("Istanbul", forKey: "cityFrom");
        newObject.setValue("Dubai", forKey: "cityTo");
        newObject.setValue("4h 30 min", forKey: "duration");
        newObject.setValue("310.0$", forKey: "price");
        
        newObject = NSEntityDescription.insertNewObject(forEntityName: "Flight", into: appDelegate.persistentContainer.viewContext) as NSManagedObject;
        newObject.setValue("Lufthansa", forKey: "company");
        newObject.setValue("Berlin", forKey: "cityFrom");
        newObject.setValue("Istanbul", forKey: "cityTo");
        newObject.setValue("3h 45min", forKey: "duration");
        newObject.setValue("160.0$", forKey: "price");
        
        newObject = NSEntityDescription.insertNewObject(forEntityName: "Flight", into: appDelegate.persistentContainer.viewContext) as NSManagedObject;
        newObject.setValue("Turkish Airlines", forKey: "company")
        newObject.setValue("Moscow", forKey: "cityFrom");
        newObject.setValue("Dubai", forKey: "cityTo");
        newObject.setValue("4h", forKey: "duration");
        newObject.setValue("350.0$", forKey: "price");
        
        newObject = NSEntityDescription.insertNewObject(forEntityName: "Flight", into: appDelegate.persistentContainer.viewContext) as NSManagedObject;
        newObject.setValue("Emirates", forKey: "company");
        newObject.setValue("Dubai", forKey: "cityFrom");
        newObject.setValue("New York", forKey: "cityTo");
        newObject.setValue("14h 00min", forKey: "duration");
        newObject.setValue("890.0$", forKey: "price");
        
        newObject = NSEntityDescription.insertNewObject(forEntityName: "Flight", into: appDelegate.persistentContainer.viewContext) as NSManagedObject;
        newObject.setValue("Qatar Airways", forKey: "company");
        newObject.setValue("Doha", forKey: "cityFrom");
        newObject.setValue("Moscow", forKey: "cityTo");
        newObject.setValue("5h 15min", forKey: "duration");
        newObject.setValue("250.0$", forKey: "price");
        
        newObject = NSEntityDescription.insertNewObject(forEntityName: "Flight", into: appDelegate.persistentContainer.viewContext) as NSManagedObject;
        newObject.setValue("Aeroflot", forKey: "company");
        newObject.setValue("Doha", forKey: "cityFrom");
        newObject.setValue("Moscow", forKey: "cityTo");
        newObject.setValue("5h 30min", forKey: "duration");
        newObject.setValue("260.0$", forKey: "price");
        
        newObject = NSEntityDescription.insertNewObject(forEntityName: "Flight", into: appDelegate.persistentContainer.viewContext) as NSManagedObject;
        newObject.setValue("British Airways", forKey: "company");
        newObject.setValue("London", forKey: "cityFrom");
        newObject.setValue("Rome", forKey: "cityTo");
        newObject.setValue("2h 30min", forKey: "duration");
        newObject.setValue("100.90$", forKey: "price");
        
        newObject = NSEntityDescription.insertNewObject(forEntityName: "Flight", into: appDelegate.persistentContainer.viewContext) as NSManagedObject;
        newObject.setValue("Alitalia", forKey: "company");
        newObject.setValue("Rome", forKey: "cityFrom");
        newObject.setValue("London", forKey: "cityTo");
        newObject.setValue("2h 45min", forKey: "duration");
        newObject.setValue("110.0$", forKey: "price");
        
        newObject = NSEntityDescription.insertNewObject(forEntityName: "Flight", into: appDelegate.persistentContainer.viewContext) as NSManagedObject;
        newObject.setValue("Delta Airlines", forKey: "company");
        newObject.setValue("New York", forKey: "cityFrom");
        newObject.setValue("Los Angeles", forKey: "cityTo");
        newObject.setValue("6h 00min", forKey: "duration");
        newObject.setValue("300.0$", forKey: "price");
        
        newObject = NSEntityDescription.insertNewObject(forEntityName: "Flight", into: appDelegate.persistentContainer.viewContext) as NSManagedObject;
        newObject.setValue("Lufthansa", forKey: "company");
        newObject.setValue("Paris", forKey: "cityFrom");
        newObject.setValue("Berlin", forKey: "cityTo");
        newObject.setValue("2h 20m", forKey: "duration");
        newObject.setValue("110.0$", forKey: "price");
        
        newObject = NSEntityDescription.insertNewObject(forEntityName: "Flight", into: appDelegate.persistentContainer.viewContext) as NSManagedObject;
        newObject.setValue("Air France", forKey: "company");
        newObject.setValue("Paris", forKey: "cityFrom");
        newObject.setValue("Berlin", forKey: "cityTo");
        newObject.setValue("1h 45min", forKey: "duration");
        newObject.setValue("80.0$", forKey: "price");
        
        newObject = NSEntityDescription.insertNewObject(forEntityName: "Flight", into: appDelegate.persistentContainer.viewContext) as NSManagedObject;
        newObject.setValue("Qatar Airways", forKey: "company");
        newObject.setValue("Moscow", forKey: "cityFrom");
        newObject.setValue("Doha", forKey: "cityTo");
        newObject.setValue("5h 45m", forKey: "duration");
        newObject.setValue("320.0$", forKey: "price");
        
        newObject = NSEntityDescription.insertNewObject(forEntityName: "Flight", into: appDelegate.persistentContainer.viewContext) as NSManagedObject;
        newObject.setValue("Emirates", forKey: "company");
        newObject.setValue("Dubai", forKey: "cityFrom");
        newObject.setValue("New York", forKey: "cityTo");
        newObject.setValue("14h 00m", forKey: "duration");
        newObject.setValue("850.0$", forKey: "price");
        
        newObject = NSEntityDescription.insertNewObject(forEntityName: "Flight", into: appDelegate.persistentContainer.viewContext) as NSManagedObject;
        newObject.setValue("Ryanair", forKey: "company");
        newObject.setValue("Dublin", forKey: "cityFrom");
        newObject.setValue("London", forKey: "cityTo");
        newObject.setValue("1h 30min", forKey: "duration");
        newObject.setValue("30.45$", forKey: "price");
        
        newObject = NSEntityDescription.insertNewObject(forEntityName: "Flight", into: appDelegate.persistentContainer.viewContext) as NSManagedObject;
        newObject.setValue("Air France", forKey: "company");
        newObject.setValue("Paris", forKey: "cityFrom");
        newObject.setValue("Berlin", forKey: "cityTo");
        newObject.setValue("2h 10m", forKey: "duration");
        newObject.setValue("99.5$", forKey: "price");
        
        try!
        appDelegate.persistentContainer.viewContext.save();
    }
    
}

