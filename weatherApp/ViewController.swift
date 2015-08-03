//
//  ViewController.swift
//  weatherApp
//
//  Created by lapacino on 8/3/15.
//  Copyright (c) 2015 lapacino. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var factLabel: UILabel!
    @IBOutlet weak var weatherApp: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func weatherButtonPressed(sender: UIButton) {
        
        let url = NSURL(string: "http://www.weather-forecast.com/locations/" + cityNameTextField.text.stringByReplacingOccurrencesOfString(" ", withString: "-") + "/forecasts/latest")
        
        if url != nil {
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                
                var urlError = false
                var weather = ""
                
                if error == nil {
                    
                    let urlContent = NSString(data: data, encoding: NSUTF8StringEncoding)
                    let urlcontentArray = urlContent!.componentsSeparatedByString("<span class=\"phrase\">")
                    
                    if urlcontentArray.count > 0 {
                        var weatherArray = urlcontentArray[1].componentsSeparatedByString("</span>")
                       var weather1 = weatherArray[0] as! String
                       weather = weather1.stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                    }
                    else{
                        urlError = true
                    }
                    
                }
                else{
                    urlError = true
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    if urlError == true {
                        self.showUrlError()
                    }
                    else{
                        self.factLabel.text = weather
                        self.weatherApp.text = "" + self.cityNameTextField.text + " Weather"
                    }
                }
                
                
            })
            task.resume()
            
          
            
            
        }
        else{
           
            showUrlError()
        }
   
            
       
    
    }
    
    func showUrlError() {
        
        factLabel.text = "loading of " + cityNameTextField.text + " failed. please try again"
    }

}

