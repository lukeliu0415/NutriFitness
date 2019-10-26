//
//  ExerciseViewController.swift
//  NutriFitness
//
//  Created by Alan Yan on 2019-10-26.
//  Copyright © 2019 Luke Liu. All rights reserved.
//

import UIKit
import HealthKit
class exerciseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var exercisePicture: UIImageView!
    @IBOutlet weak var minutes: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
class ExerciseViewController: UIViewController {
    let exerciseDictionary: [String: Double] = ["Swimming" : 10, "Running": 10, "Hockey": 8, "Dodgeball": 5, "Walking": 3]
    var caloriesActiveBurned: Double = 0
    var caloriesEaten: Double = 0
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.title = "Exercise"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        updateCaloriesEaten()
        updateCalorieInformation()
        print(caloriesActiveBurned)
        print(caloriesEaten)
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
                        self.tableView.reloadData()
                        }
                    }
                    healthStore.execute(query)
                }
            }

        }
    }
    
    func updateCalorieInformation() {
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
                    print("doing calender struff")
                    let calendar = NSCalendar.current
                    let now = NSDate()
                    let components = calendar.dateComponents([.year, .month, .day], from: now as Date)
                     
                    guard let startDate = calendar.date(from: components) else {
                        fatalError("*** Unable to create the start date ***")
                    }
                     
                    let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)
                     
                    guard let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned) else {
                        fatalError("*** This method should never fail ***")
                    }
                    let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])

                    
                    print("doing calender struff")

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
                        self.caloriesActiveBurned = sum
                        self.tableView.reloadData()
                        }
                    }
                    healthStore.execute(query)
                }
            }

        }
    }
}


extension ExerciseViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseDictionary.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath)
        guard let newCell = cell as? exerciseTableViewCell else {
            return cell
        }
        newCell.name.text = Array(exerciseDictionary.keys)[indexPath.row]
        let netCals: Double = (caloriesEaten - caloriesActiveBurned - 1000.0 + 2000.0)
        let divider: Double = exerciseDictionary[Array(exerciseDictionary.keys)[indexPath.row]]!
        
        let minutes: Double = netCals/divider
        newCell.minutes.text = String(minutes)
        return newCell
    }
    
    
    
}
