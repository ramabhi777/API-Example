//
//  ViewController.swift
//  ApiDemo
//
//  Created by Appinventiv on 13/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UISearchBarDelegate
{
    var locationarray = [location]()
  
    @IBOutlet weak var ClickbtnOutlet: UIButton!
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var SearchTextField: UISearchBar!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.DelegateCalls()
    }

    @IBAction func ClickBtn(_ sender: UIButton)
    {
        getData()
        locationarray = []
        self.TableView.reloadDataAfterDelay()
        TableView.reloadData()
        //fetchImage()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        ClickbtnOutlet.layer.cornerRadius = 10
        TableView.layer.cornerRadius = 6
        TableView.clipsToBounds = true
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "Mapid") as! Map
//        navigationController?.pushViewController(vc, animated: true)
//        vc.latitude = locationarray[indexPath.row].langitude
//        vc.longitude = locationarray[indexPath.row].longitude
//    }
}


extension ViewController{
    
    func DelegateCalls(){
        TableView.delegate = self
        TableView.dataSource = self
        SearchTextField.delegate = self
    }
    
func getData(){

    let searchvalue = SearchTextField.text!.replacingOccurrences(of: " ", with: "+")

   
    let request = NSMutableURLRequest(url: NSURL(string: "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(searchvalue)&key=AIzaSyCxQOTThX6yKGVPxrEcMBAOr_IcZkDhGLQ")! as URL,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 10.0)
    
    request.httpMethod = "GET"

    URLSession.shared.dataTask(with: request as URLRequest, completionHandler:
     { (data, response, error) -> Void in
           if (error != nil)
             {
               print(error! )
             }
           else
             {
               let httpResponse = response as? HTTPURLResponse
               print(httpResponse!)
             }
 
           guard let d = data else{ return }
           let fetchData = try! JSONSerialization.jsonObject(with: d, options: .mutableContainers) as? NSDictionary
           print(fetchData!)

           let array = fetchData!["results"] as? [[String: Any]]
        
           for object in array!
             {
               let name = object["name"] ?? ""
               let address = object["formatted_address"] ?? ""
               let rating = object["rating"]
            
                let value = location(name: name as! String , address: address as! String, rating: rating as! NSNumber, photoRef: "", langitude: 0.0, longitude: 0.0 )

               guard let photo = object["photos"] as? [[String: Any]] else { return }
                  for pic in photo
                    {
                       let picRef = pic["photo_reference"] ?? ""
                       value.photoRef = picRef as! String
                    }
                guard let location = object["geometry"] as?  [[String: Any]] else { return }
                
                for loc in location
                {
                    let lat = loc["latitude"]
                    let lang = loc["longitude"]
                    value.langitude = lat as! Float32
                    value.longitude = lang as! Float32
                }
                
               self.locationarray.append(value)
               print(self.locationarray)
                
              }
        print(fetchData!)
        
    }).resume()
}

}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.locationarray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCellid") as! DetailCell
        cell.NameLabel.text = locationarray[indexPath.row].name
        cell.idLabel.text = locationarray[indexPath.row].address
        cell.Rating.text = String(describing: locationarray[indexPath.row].rating)
        
        
        let ref = self.locationarray[indexPath.row].photoRef
        let strUrl = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(ref)&key=AIzaSyCxQOTThX6yKGVPxrEcMBAOr_IcZkDhGLQ"
        
        if let url = URL(string:strUrl)
        {
            if let data = NSData(contentsOf: url as URL)
            {
                if let image = UIImage(data: data as Data)
                {
                    cell.PlaceImgView.image = image
                }
            }
        }

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(indexPath.row % 2 == 0 )
        {
             cell.backgroundColor = UIColor.init(red: 84/255, green: 168/255, blue: 169/255, alpha: 1)
        }
        else {
            cell.backgroundColor = UIColor.white
        }
        
        
        //let transform  = CATransform3DTranslate(CATransform3DIdentity, 10, -200 ,2)
       // cell.layer.transform = transform
        
        cell.alpha = 0.0
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        //  cell.layer.borderWidth = 1.0
       // cell.layer.borderColor = UIColor.black.cgColor
        
        cell.layer.cornerRadius = 10
        let shadowPath2 = UIBezierPath(rect: cell.bounds)
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: CGFloat(1.0), height: CGFloat(3.0))
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowPath = shadowPath2.cgPath
        
        UIView.animate(withDuration: 1.5) {
            cell.alpha = 1.0
           cell.layer.transform = CATransform3DIdentity
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
     {
        return 100
     }
 }

extension UITableView {
    
    // Default delay time = 0.5 seconds
    // Pass delay time interval, as a parameter argument
    func reloadDataAfterDelay(delayTime: TimeInterval = 3.0) -> Void {
        self.perform(#selector(self.reloadData), with: nil, afterDelay: delayTime)
    }
    
}
