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
    @IBOutlet weak var carbsPercent: UILabel!
    @IBOutlet weak var carbsBar: UIView!
    @IBOutlet weak var fatPercent: UILabel!
    @IBOutlet weak var farBar: UIView!
    @IBOutlet weak var sugarPercent: UILabel!
    @IBOutlet weak var sugarBar: UIView!
    @IBOutlet weak var sodiumPercent: UILabel!
    @IBOutlet weak var sodiumBar: UIView!
    @IBOutlet weak var proteinPercent: UILabel!
    @IBOutlet weak var proteinBar: UIView!
    @IBOutlet weak var calciumPercent: UILabel!
    @IBOutlet weak var calciumBar: UIView!
    @IBOutlet weak var cholesterolPercent: UILabel!
    @IBOutlet weak var cholesterolBar: UIView!
    
    
    
    
    
    
    
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
        if UserDefaults.standard.bool(forKey: "Onboard") != true {
            self.performSegue(withIdentifier: "toOnboard", sender: self)
            UserDefaults.standard.set(true, forKey: "Onboard")
        }
        updateCaloriesEaten()
        viewSetup()
    }
    func viewSetup() {
        for x in [carbsBar, sugarBar, cholesterolBar, calciumBar, farBar, sodiumBar, proteinBar] {
            x?.backgroundColor = .orange
            x?.layer.cornerRadius = 10
            x?.layer.masksToBounds = true
            x?.clipsToBounds = true
        }
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
                            
                        var sum: Double = 0
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
                                               
                                           var sum: Double = 0
                                               for sample in samples2 {
                                                   
                                                   let calories = sample.quantity.doubleValue(for: HKUnit.gram())
                                                   sum += calories
                                               }
                                        self.sugarEaten = sum/32.5 * 100
                                            self.sugarEaten.round()
                                            self.sugarPercent.text = "\(self.sugarEaten)%"
                                           if self.sugarEaten > 100 {
                                               self.sugarBar.backgroundColor = .red
                                               self.sugarBar.frame =  CGRect(x: 20, y: 0, width: 30, height: 150)
                                           } else if self.sugarEaten < 0 {
                                               self.sugarBar.frame =  CGRect(x: 20, y: 0, width: 30, height: 0)
                                           } else {
                                            self.sugarBar.frame =  CGRect(x: 20, y: 0, width: 30, height: self.sugarEaten * 1.50)
                                           }

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
                                               
                                           var sum: Double = 0
                                               for sample in samples {
                                                   
                                                   let calories = sample.quantity.doubleValue(for: HKUnit.gram())
                                                   sum += calories
                                               }
                                           self.proteinEaten = sum/50 * 100
                                            self.proteinEaten.round()
                                            self.proteinPercent.text = "\(self.proteinEaten)%"
                                           if self.proteinEaten > 100 {
                                               self.proteinBar.backgroundColor = .red
                                               self.proteinBar.frame =  CGRect(x: 40, y: 0, width: 30, height: 150)
                                           } else if self.proteinEaten < 0 {
                                               self.proteinBar.frame =  CGRect(x: 40, y: 0, width: 30, height: 0)
                                           } else {
                                            self.proteinBar.frame =  CGRect(x: 40, y: 0, width: 30, height: self.proteinEaten * 1.5)
                                           }
                                           }
                                       }
                                       healthStore.execute(query3)
                    
                    
                    //MARK: Cholesterol
                    
                    guard let sampleType4 = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCholesterol) else {
                                           fatalError("*** This method should never fail ***")
                                       }

                                      let query4 = HKSampleQuery(sampleType: sampleType4, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) {
                                           query, results, error in
                                           print("in query struff")

                                           guard let samples = results as? [HKQuantitySample] else {
                                               fatalError("An error occured fetching the user's tracked food. In your app, try to handle this error gracefully. The error was: \(error?.localizedDescription)");
                                           }
                                           
                                       DispatchQueue.main.async {
                                               
                                           var sum: Double = 0
                                               for sample in samples {
                                                   
                                                   let calories = sample.quantity.doubleValue(for: HKUnit.gram())
                                                   sum += calories
                                               }
                                           self.cholesterolEaten = sum/50 * 100
                                            self.cholesterolEaten.round()
                                            self.cholesterolPercent.text = "\(self.cholesterolEaten)%"
                                           if self.cholesterolEaten > 100 {
                                               self.cholesterolBar.backgroundColor = .red
                                               self.cholesterolBar.frame =  CGRect(x: 40, y: 0, width: 30, height: 150)
                                           } else if self.cholesterolEaten < 0 {
                                               self.cholesterolBar.frame =  CGRect(x: 40, y: 0, width: 30, height: 0)
                                           } else {
                                            self.cholesterolBar.frame =  CGRect(x: 40, y: 0, width: 30, height: self.cholesterolEaten * 1.50)
                                           }
                                           }
                                       }
                                       healthStore.execute(query4)
                    //MARK: Fat
                    
                    guard let sampleType5 = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFatTotal) else {
                                           fatalError("*** This method should never fail ***")
                                       }

                                      let query5 = HKSampleQuery(sampleType: sampleType5, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) {
                                           query, results, error in
                                           print("in query struff")

                                           guard let samples = results as? [HKQuantitySample] else {
                                               fatalError("An error occured fetching the user's tracked food. In your app, try to handle this error gracefully. The error was: \(error?.localizedDescription)");
                                           }
                                           
                                       DispatchQueue.main.async {
                                               
                                           var sum: Double = 0
                                               for sample in samples {
                                                   
                                                   let calories = sample.quantity.doubleValue(for: HKUnit.gram())
                                                   sum += calories
                                               }
                                           self.fatEaten = sum/50 * 100
                                            self.fatEaten.round()
                                            self.fatPercent.text = "\(self.fatEaten)%"
                                           if self.fatEaten > 100 {
                                               self.farBar.backgroundColor = .red
                                               self.farBar.frame =  CGRect(x: 20, y: 0, width: 30, height: 150)
                                           } else if self.fatEaten < 0 {
                                               self.farBar.frame =  CGRect(x: 20, y: 0, width: 30, height: 0)
                                           } else {
                                               self.farBar.frame =  CGRect(x: 20, y: 0, width: 30, height: self.fatEaten/100 * 150)
                                           }
                                           }
                                       }
                                       healthStore.execute(query5)
                    //MARK: Sodium
                    guard let sampleType6 = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietarySodium) else {
                                           fatalError("*** This method should never fail ***")
                                       }

                                      let query6 = HKSampleQuery(sampleType: sampleType6, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) {
                                           query, results, error in
                                           print("in query struff")

                                           guard let samples = results as? [HKQuantitySample] else {
                                               fatalError("An error occured fetching the user's tracked food. In your app, try to handle this error gracefully. The error was: \(error?.localizedDescription)");
                                           }
                                           
                                       DispatchQueue.main.async {
                                               
                                           var sum: Double = 0
                                               for sample in samples {
                                                   
                                                   let calories = sample.quantity.doubleValue(for: HKUnit.gram())
                                                   sum += calories
                                               }
                                           self.sodiumEaten = sum/2 * 100
                                            self.sodiumEaten.round()
                                            self.sodiumPercent.text = "\(self.sodiumEaten)%"
                                           if self.sodiumEaten > 100 {
                                               self.sodiumBar.backgroundColor = .red
                                               self.sodiumBar.frame =  CGRect(x: 20, y: 0, width: 30, height: 150)
                                           } else if self.sodiumEaten < 0 {
                                               self.sodiumBar.frame =  CGRect(x: 20, y: 0, width: 30, height: 0)
                                           } else {
                                               self.sodiumBar.frame =  CGRect(x: 20, y: 0, width: 30, height: self.sodiumEaten/100 * 150)
                                           }

                                           }
                                       }
                                       healthStore.execute(query6)
                    
                    //MARK: Carbs
                    guard let sampleType7 = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCarbohydrates) else {
                         fatalError("*** This method should never fail ***")
                     }

                    let query7 = HKSampleQuery(sampleType: sampleType7, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) {
                         query, results, error in
                         print("in query struff")

                         guard let samples = results as? [HKQuantitySample] else {
                             fatalError("An error occured fetching the user's tracked food. In your app, try to handle this error gracefully. The error was: \(error?.localizedDescription)");
                         }
                         
                     DispatchQueue.main.async {
                             
                         var sum: Double = 0
                             for sample in samples {
                                 
                                 let calories = sample.quantity.doubleValue(for: HKUnit.gram())
                                 sum += calories
                             }
                         self.carbsEaten = sum/250 * 100
                         self.carbsEaten.round()
                         self.carbsPercent.text = "\(self.carbsEaten)%"
                        if self.carbsEaten > 100 {
                            self.carbsBar.backgroundColor = .red
                            self.carbsBar.frame =  CGRect(x: 20, y: 0, width: 30, height: 150)
                        } else if self.carbsEaten < 0 {
                            self.carbsBar.frame =  CGRect(x: 20, y: 0, width: 30, height: 0)
                        } else {
                            self.carbsBar.frame =  CGRect(x: 20, y: 0, width: 30, height: self.carbsEaten/100 * 150)
                        }
                        

                         }
                     }
                     healthStore.execute(query7)
                    
                    //MARK: Calcium
                    
                    guard let sampleType8 = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCalcium) else {
                         fatalError("*** This method should never fail ***")
                     }

                    let query8 = HKSampleQuery(sampleType: sampleType8, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) {
                         query, results, error in
                         print("in query struff")

                         guard let samples = results as? [HKQuantitySample] else {
                             fatalError("An error occured fetching the user's tracked food. In your app, try to handle this error gracefully. The error was: \(error?.localizedDescription)");
                         }
                         
                     DispatchQueue.main.async {
                             
                         var sum: Double = 0
                             for sample in samples {
                                 
                                 let calories = sample.quantity.doubleValue(for: HKUnit.gram())
                                 sum += calories
                             }
                        self.calciumEaten = sum * 100
                         self.calciumEaten.round()
                         self.calciumPercent.text = "\(self.calciumEaten)%"
                        if self.calciumEaten > 100 {
                            self.calciumBar.backgroundColor = .red
                            self.calciumBar.frame =  CGRect(x: 40, y: 0, width: 30, height: 150)
                        } else if self.calciumEaten < 0 {
                            self.calciumBar.frame =  CGRect(x: 40, y: 0, width: 30, height: 0)
                        } else {
                            self.calciumBar.frame =  CGRect(x: 40, y: 0, width: 30, height: self.calciumEaten * 1.50)
                        }
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
        guard let calories = data["ENERC_KCAL"] as? Double else {
             return
        }
        guard let calorie = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed) else {
           fatalError("Body Mass Index Type is no longer available in HealthKit")
         }
           
         //2.  Use the Count HKUnit to create a body mass quantity
        let bodyMassQuantity = HKQuantity(unit: HKUnit.largeCalorie(),
                                           doubleValue: calories)
           
         let bodyMassIndexSample = HKQuantitySample(type: calorie,
                                                    quantity: bodyMassQuantity,
                                                    start: Date(),
                                                    end: Date())
           
         //3.  Save the same to HealthKit
         HKHealthStore().save(bodyMassIndexSample) { (success, error) in
             
           if let error = error {
             print("Error Saving Calorie Sample: \(error.localizedDescription)")
           } else {
             print("Successfully saved Calorie Sample")
           }
         }
        
        guard let fats = data["FAT"] as? Double else {
             return
        }
        guard let fat = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFatTotal) else {
           fatalError("Body Mass Index Type is no longer available in HealthKit")
         }
           
         //2.  Use the Count HKUnit to create a body mass quantity
        let fatQuantity = HKQuantity(unit: HKUnit.gram(),
                                           doubleValue: fats)
           
         let fatSample = HKQuantitySample(type: fat,
                                                    quantity: fatQuantity,
                                                    start: Date(),
                                                    end: Date())
           
         //3.  Save the same to HealthKit
         HKHealthStore().save(fatSample) { (success, error) in
             
           if let error = error {
             print("Error Saving Fat Sample: \(error.localizedDescription)")
           } else {
             print("Successfully saved Fat Sample")
           }
         }
        
        
        guard let carbs = data["CHOCDF"] as? Double else {
             return
        }
        guard let carb = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCarbohydrates) else {
           fatalError("Body Mass Index Type is no longer available in HealthKit")
         }
           
         //2.  Use the Count HKUnit to create a body mass quantity
        let carbQuantity = HKQuantity(unit: HKUnit.gram(),
                                           doubleValue: carbs)
           
         let carbSample = HKQuantitySample(type: carb,
                                                    quantity: carbQuantity,
                                                    start: Date(),
                                                    end: Date())
           
         //3.  Save the same to HealthKit
         HKHealthStore().save(carbSample) { (success, error) in
             
           if let error = error {
             print("Error Saving Carb Sample: \(error.localizedDescription)")
           } else {
             print("Successfully saved Carb Sample")
           }
         }
        
        
        guard let proteins = data["PROCNT"] as? Double else {
             return
        }
        guard let protein = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryProtein) else {
           fatalError("Body Mass Index Type is no longer available in HealthKit")
         }
           
         //2.  Use the Count HKUnit to create a body mass quantity
        let proteinQuantity = HKQuantity(unit: HKUnit.gram(),
                                           doubleValue: proteins)
           
         let proteinSample = HKQuantitySample(type: protein,
                                                    quantity: proteinQuantity,
                                                    start: Date(),
                                                    end: Date())
           
         //3.  Save the same to HealthKit
         HKHealthStore().save(proteinSample) { (success, error) in
             
           if let error = error {
             print("Error Saving Protein Sample: \(error.localizedDescription)")
           } else {
             print("Successfully saved Protein Sample")
           }
         }
        updateCaloriesEaten()
        
        
    }
}
