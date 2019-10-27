//
//  NutritionFactsViewController.swift
//  NutriFitness
//
//  Created by Luke Liu on 2019-10-26.
//  Copyright © 2019 Luke Liu. All rights reserved.
//

import Alamofire
import UIKit

class NutritionFactsViewController: UIViewController {

    var food: String?
    var upperDataInterface: dataInterface?
    
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var carbAmount: UILabel!
    @IBOutlet weak var fatAmount: UILabel!
    @IBOutlet weak var proteinAmount: UILabel!
    @IBOutlet weak var calAmount: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("what is food?: \(food)")
        api()
    }
    
    @IBAction func backButton(_ sender: Any) {
        upperDataInterface?.dismissCameraView()
        dismiss(animated: true, completion: nil)
    }
    
    func api()  {
       var URL = "https://api.edamam.com/api/food-database/parser?ingr=\(food!)&app_id=a3ce3438&app_key=57b2ac41de93ffdc20ac93ec2b8f7f18"
       
        Alamofire.request("https://api.edamam.com/api/food-database/parser?ingr=water%20bottle&app_id=a3ce3438&app_key=57b2ac41de93ffdc20ac93ec2b8f7f18").responseJSON { response in
            if let result = response.result.value {
                let JSON = result as! NSDictionary
                let parsed = JSON["parsed"] as! Array<NSDictionary>
                let food = parsed[0]["food"] as! NSDictionary
                let label = food["label"] as! String
                self.foodLabel.text = label
                print("this is label: \(label)")
                self.upperDataInterface?.passDataBack(data: food)
            }
        }
    }
}
