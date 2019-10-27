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
    var sugarEaten: Double = 0
    var cholesterolEaten: Double = 0
    var carbsEaten: Double = 0
    var proteinEaten: Double = 0
    var sodiumEaten: Double = 0
    var calciumEaten: Double = 0
    var fatEaten: Double = 0


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
                     
                   
                    let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])

                    guard let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed) else {
                        fatalError("*** This method should never fail ***")
                    }

                   let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) {
                        query, results, error in
                        print("in query struff")

                        guard let samples = results as? [HKQuantitySample] else {
                            fatalError("An error occured fetching the user's tracked food. In your app, try to handle this error gracefully. The error was: \(error?.localizedDescription)");
                        }
                        
                    DispatchQueue.main.async {
                            
                        var sum: Double = self.caloriesEaten
                            for sample in samples {
                                
                                let calories = sample.quantity.doubleValue(for: HKUnit.largeCalorie())
                                sum += calories
                            }
                        self.caloriesEaten = sum
                        self.calorieLabel.text = String(sum)

                        }
                    }
                    healthStore.execute(query)
                    
                    
                    
                    
                    //MARK: Sugar
                    
                    guard let sampleType2 = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietarySugar) else {
                                           fatalError("*** This method should never fail ***")
                                       }

                                      let query2 = HKSampleQuery(sampleType: sampleType2, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) {
                                           query, results, error in
                                           print("in query struff")

                                           guard let samples2 = results as? [HKQuantitySample] else {
                                               fatalError("An error occured fetching the user's tracked food. In your app, try to handle this error gracefully. The error was: \(error?.localizedDescription)");
                                           }
                                           
                                       DispatchQueue.main.async {
                                               
                                           var sum: Double = self.caloriesEaten
                                               for sample in samples2 {
                                                   
                                                   let calories = sample.quantity.doubleValue(for: HKUnit.largeCalorie())
                                                   sum += calories
                                               }
                                           self.caloriesEaten = sum
                                           self.calorieLabel.text = String(sum)

                                           }
                                       }
                                       healthStore.execute(query2)
                    //MARK: Protein
                    
                    guard let sampleType3 = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryProtein) else {
                                           fatalError("*** This method should never fail ***")
                                       }

                                      let query3 = HKSampleQuery(sampleType: sampleType3, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) {
                                           query, results, error in
                                           print("in query struff")

                                           guard let samples = results as? [HKQuantitySample] else {
                                               fatalError("An error occured fetching the user's tracked food. In your app, try to handle this error gracefully. The error was: \(error?.localizedDescription)");
                                           }
                                           
                                       DispatchQueue.main.async {
                                               
                                           var sum: Double = self.caloriesEaten
                                               for sample in samples {
                                                   
                                                   let calories = sample.quantity.doubleValue(for: HKUnit.largeCalorie())
                                                   sum += calories
                                               }
                                           self.caloriesEaten = sum
                                           self.calorieLabel.text = String(sum)

                                           }
                                       }
                                       healthStore.execute(query3)
                    
                    
                    //MARK: Cholesterol
                    
                    guard let sampleType4 = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed) else {
                                           fatalError("*** This method should never fail ***")
                                       }

                                      let query4 = HKSampleQuery(sampleType: sampleType4, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) {
                                           query, results, error in
                                           print("in query struff")

                                           guard let samples = results as? [HKQuantitySample] else {
                                               fatalError("An error occured fetching the user's tracked food. In your app, try to handle this error gracefully. The error was: \(error?.localizedDescription)");
                                           }
                                           
                                       DispatchQueue.main.async {
                                               
                                           var sum: Double = self.caloriesEaten
                                               for sample in samples {
                                                   
                                                   let calories = sample.quantity.doubleValue(for: HKUnit.largeCalorie())
                                                   sum += calories
                                               }
                                           self.caloriesEaten = sum
                                           self.calorieLabel.text = String(sum)

                                           }
                                       }
                                       healthStore.execute(query4)
                    //MARK: Fat
                    
                    guard let sampleType5 = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed) else {
                                           fatalError("*** This method should never fail ***")
                                       }

                                      let query5 = HKSampleQuery(sampleType: sampleType5, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) {
                                           query, results, error in
                                           print("in query struff")

                                           guard let samples = results as? [HKQuantitySample] else {
                                               fatalError("An error occured fetching the user's tracked food. In your app, try to handle this error gracefully. The error was: \(error?.localizedDescription)");
                                           }
                                           
                                       DispatchQueue.main.async {
                                               
                                           var sum: Double = self.caloriesEaten
                                               for sample in samples {
                                                   
                                                   let calories = sample.quantity.doubleValue(for: HKUnit.largeCalorie())
                                                   sum += calories
                                               }
                                           self.caloriesEaten = sum
                                           self.calorieLabel.text = String(sum)

                                           }
                                       }
                                       healthStore.execute(query5)
                    //MARK: Sodium
                    guard let sampleType6 = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed) else {
                                           fatalError("*** This method should never fail ***")
                                       }

                                      let query6 = HKSampleQuery(sampleType: sampleType6, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) {
                                           query, results, error in
                                           print("in query struff")

                                           guard let samples = results as? [HKQuantitySample] else {
                                               fatalError("An error occured fetching the user's tracked food. In your app, try to handle this error gracefully. The error was: \(error?.localizedDescription)");
                                           }
                                           
                                       DispatchQueue.main.async {
                                               
                                           var sum: Double = self.caloriesEaten
                                               for sample in samples {
                                                   
                                                   let calories = sample.quantity.doubleValue(for: HKUnit.largeCalorie())
                                                   sum += calories
                                               }
                                           self.caloriesEaten = sum
                                           self.calorieLabel.text = String(sum)

                                           }
                                       }
                                       healthStore.execute(query6)
                    
                    //MARK: Carbs
                    guard let sampleType7 = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed) else {
                         fatalError("*** This method should never fail ***")
                     }

                    let query7 = HKSampleQuery(sampleType: sampleType7, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) {
                         query, results, error in
                         print("in query struff")

                         guard let samples = results as? [HKQuantitySample] else {
                             fatalError("An error occured fetching the user's tracked food. In your app, try to handle this error gracefully. The error was: \(error?.localizedDescription)");
                         }
                         
                     DispatchQueue.main.async {
                             
                         var sum: Double = self.caloriesEaten
                             for sample in samples {
                                 
                                 let calories = sample.quantity.doubleValue(for: HKUnit.largeCalorie())
                                 sum += calories
                             }
                         self.caloriesEaten = sum
                         self.calorieLabel.text = String(sum)

                         }
                     }
                     healthStore.execute(query7)
                    
                    //MARK: Calcium
                    
                    guard let sampleType8 = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed) else {
                         fatalError("*** This method should never fail ***")
                     }

                    let query8 = HKSampleQuery(sampleType: sampleType8, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) {
                         query, results, error in
                         print("in query struff")

                         guard let samples = results as? [HKQuantitySample] else {
                             fatalError("An error occured fetching the user's tracked food. In your app, try to handle this error gracefully. The error was: \(error?.localizedDescription)");
                         }
                         
                     DispatchQueue.main.async {
                             
                         var sum: Double = self.caloriesEaten
                             for sample in samples {
                                 
                                 let calories = sample.quantity.doubleValue(for: HKUnit.largeCalorie())
                                 sum += calories
                             }
                         self.caloriesEaten = sum
                         self.calorieLabel.text = String(sum)

                         }
                     }
                     healthStore.execute(query8)
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
        if let calories = data["ENERC_KCAL"] as? Double {
            caloriesEaten += calories
        }
        updateCaloriesEaten()
        
        
    }
}
