//
//  ThirdViewController.swift
//  BrestFortressMonuments
//
//  Created by Victoria Samsonova on 10.05.24.
//

import UIKit

class ThirdViewController: UIViewController {

    @IBOutlet weak var ImageOnPage: UIImageView!
    @IBOutlet weak var NameOnPage: UILabel!
    @IBOutlet weak var DescriptionOnPage: UILabel!
    @IBOutlet weak var CoordinatesOnPage: UILabel!
    
    @IBOutlet var thirdView: UIView!
    
    var selectedMonument: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        guard let selectedMonument = selectedMonument else {
               print("Error: selectedMonument is nil")
               return
        }
        print("Selected monument: \(selectedMonument)")
        NameOnPage.text = selectedMonument.object(forKey: "Name") as? String
        DescriptionOnPage.text = selectedMonument.object(forKey: "Description") as? String
        ImageOnPage.image = UIImage(named: selectedMonument.object(forKey: "Image") as! String)
        CoordinatesOnPage.text = selectedMonument.object(forKey: "Coordinates") as? String
    }
}
