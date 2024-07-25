//
//  ViewController.swift
//  BrestFortressMonuments
//
//  Created by Victoria Samsonova on 10.05.24.
//

import UIKit

class ViewController: UIViewController {
    

    @IBOutlet weak var regView: UIView!
    @IBOutlet weak var switchScreen: UISegmentedControl!
    
    @IBOutlet weak var loginLog: UITextField!
    @IBOutlet weak var passwordLog: UITextField!
    
    @IBOutlet weak var loginReg: UITextField!
    @IBOutlet weak var mailReg: UITextField!
    @IBOutlet weak var passwordReg: UITextField!
    @IBOutlet weak var repeatPasswordReg: UITextField!
    
    @IBOutlet weak var agree: UISwitch!
    
    @IBAction func tap(_ sender: Any) {
        if switchScreen.selectedSegmentIndex == 1 {
            if ((loginReg.text! == "") || (passwordReg.text! == "")) {
                let alert = UIAlertController(title: "Impossible!", message: "You should input data!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(okAction)
                present(alert, animated: true)
                
            }
            if agree.isOn {
                UserDefaults.standard.set(loginReg.text!, forKey: "login")
                UserDefaults.standard.set(passwordReg.text!, forKey: "password")
                performSegue(withIdentifier: "showList", sender: self)
            }
            else {
                let alert = UIAlertController(title: "Impossible!", message: "You should agree!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(okAction)
                present(alert, animated: true)
            }
        }
        else {
            if ((loginLog.text! == "") || (passwordLog.text! == "")) {
                let alert = UIAlertController(title: "Impossible!", message: "You should input data!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(okAction)
                present(alert, animated: true)
            }
            else {
                UserDefaults.standard.set(loginLog.text!, forKey: "login")
                UserDefaults.standard.set(passwordLog.text!, forKey: "password")
                performSegue(withIdentifier: "showList", sender: self)
            }
        }
    }
    
    @IBAction func chooseScreen(_ sender: Any) {
        if switchScreen.selectedSegmentIndex == 1 {
            regView.isHidden = false
        }
        else {
            regView.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        regView.isHidden = true
        if ((UserDefaults.standard.object(forKey: "login")) != nil) {
            performSegue(withIdentifier: "showList", sender: self)
        }
    }


}

