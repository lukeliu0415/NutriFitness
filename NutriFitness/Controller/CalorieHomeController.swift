//
//  CalorieHomeController.swift
//  NutriFitness
//
//  Created by Alan Yan on 2019-10-26.
//  Copyright © 2019 Luke Liu. All rights reserved.
//

import UIKit
import HealthKit

class CalorieHomeController: UIViewController {
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var backImage: UIImageView!
    
    var caloriesEaten: Double = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.title = "Nutrition"
        backImage.clipsToBounds = true
        backImage.layer.cornerRadius = backImage.bounds.size.width/2
        backImage.layer.masksToBounds = true
        self.performSegue(withIdentifier: "toOnboard", sender: self)
        updateCaloriesEaten()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCameraSegue" {
            let vc = segue.destination as! CameraViewController
            vc.upperDataInterface = self
        }
    }
    
    func updateCaloriesEaten() {
        if HKHealthStore.isHealthDataAvailable() {
            // Add code to use HealthKit here.
            let healthStore = HKHealthStore()
            let allTypes = Set([HKObjectType.workoutType(),
                                HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                                HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!])

            healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
                if !success {
                    // Handle the error here.
                    print(error)
                }
                else {
                    let calendar = NSCalendar.current
                    let now = NSDate()
                    let components = calendar.dateComponents([.year, .month, .day], from: now as Date)
                     
                    guard let startDate = calendar.date(from: components) else {
                        fatalError("*** Unable to create the start date ***")
                    }
                     
                    let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)
                     
                    guard let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed) else {
                        fatalError("*** This method should never fail ***")
                    }
                    let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])

                    

                   let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) {
                        query, results, error in
                        print("in query struff")

                        guard let samples = results as? [HKQuantitySample] else {
                            fatalError("An error occured fetching the user's tracked food. In your app, try to handle this error gracefully. The error was: \(error?.localizedDescription)");
                        }
                        
                    DispatchQueue.main.async {
                            
                            var sum: Double = 0.0
                            for sample in samples {
                                
                                let calories = sample.quantity.doubleValue(for: HKUnit.largeCalorie())
                                sum += calories
                            }
                        self.caloriesEaten = sum
                        self.calorieLabel.text = String(sum)

                        }
                    }
                    healthStore.execute(query)
                }
            }

        }
    }
}

extension CalorieHomeController: dataInterface {
    func dismissCameraView() {
        // dont do anything
    }
    
    func passDataBack(data: NSDictionary) {
        print("back out \(data["label"]!)")
        
    }
}
