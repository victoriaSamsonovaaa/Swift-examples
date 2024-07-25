//
//  SecondViewController.swift
//  BrestFortressMonuments
//
//  Created by Victoria Samsonova on 10.05.24.
//

import UIKit

class SecondViewController: UIViewController {

@IBOutlet weak var collectionView: UICollectionView!
    
    var InfoList = NSDictionary();
    override func viewDidLoad() {
        super.viewDidLoad()
            // Do any additional setup after loading the view.
        let path = Bundle.main.path(forResource: "MonumentInfo", ofType: "plist")
        InfoList = NSDictionary(contentsOfFile: path!)!
            
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let thirdViewController = segue.destination as? ThirdViewController,
           let indexPath = collectionView.indexPathsForSelectedItems?.first {
        let monumentInfo = InfoList.object(forKey: ((InfoList.allKeys) [indexPath.item])) as! NSDictionary
            thirdViewController.selectedMonument = monumentInfo
        }
    }
    
}
extension SecondViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return InfoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonumentsCollectionViewCell", for: indexPath) as! MonumentsCollectionViewCell
        let monumentInfo = (InfoList.object(forKey: ((InfoList.allKeys) [indexPath.row]))) as! NSDictionary;
        cell.monumentImageView.image = UIImage(named: monumentInfo.object(forKey: "Image") as! String)
        cell.monumentNameLabel.text = monumentInfo.object(forKey: "Name") as? String
        return cell
    }
}

extension SecondViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 400, height: 300)
    }
}


extension SecondViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let monumentInfo = InfoList.object(forKey: ((InfoList.allKeys) [indexPath.item])) as? NSDictionary {
            let thirdViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThirdViewController") as! ThirdViewController
            thirdViewController.selectedMonument = monumentInfo
            navigationController?.pushViewController(thirdViewController, animated: true)
           // print("Monument info: \(monumentInfo)")
        }
        print("InfoList: \(InfoList)")
    }
}

