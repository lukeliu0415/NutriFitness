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
       let URL = "https://api.edamam.com/api/food-database/parser?ingr=\(food!)&app_id=a3ce3438&app_key=57b2ac41de93ffdc20ac93ec2b8f7f18"
       let newURL = URL.replacingOccurrences(of: " ", with: "%20")
        print(newURL)
        Alamofire.request(newURL).responseJSON { response in
            if let result = response.result.value {
                let JSON = result as! NSDictionary
                let parsed = JSON["parsed"] as! Array<NSDictionary>
                let food = parsed[0]["food"] as! NSDictionary
                let label = food["label"] as! String
                let nutrients = food["nutrients"] as! NSDictionary
                if let calories = nutrients["ENERC_KCAL"] as? Double {
                    self.calAmount.text = "\(calories)"
                } else {
                    self.calAmount.text = "0.0"
                }
                if let fat = nutrients["FAT"] as? Double {
                    self.fatAmount.text = "\(fat)"
                } else {
                    self.fatAmount.text = "0.0"
                }
                if let carbs = nutrients["CHOCDF"] as? Double {
                    self.carbAmount.text = "\(carbs)"
                } else {
                    self.carbAmount.text = "0.0"
                }
                if let protein = nutrients["PROCNT"] as? Double {
                    self.proteinAmount.text = "\(protein)"
                } else {
                    self.proteinAmount.text = "0.0"
                }
                self.foodLabel.text = label
                self.upperDataInterface?.passDataBack(data: nutrients)
            }
        }
    }
}
