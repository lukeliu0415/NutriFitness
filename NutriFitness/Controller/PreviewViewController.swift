//
//  PreviewViewController.swift
//  NutriFitness
//
//  Created by Luke Liu on 2019-10-26.
//  Copyright © 2019 Luke Liu. All rights reserved.
//

import UIKit
import AVKit
import UIKit
import CoreML
import Vision
import ImageIO

class PreviewViewController: UIViewController {

    var upperDataInterface: dataInterface?
    @IBOutlet weak var photo: UIImageView!
    var image: UIImage!
    @IBOutlet weak var classificationLabel: UILabel!
    var sfood: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        classificationLabel.layer.cornerRadius = classificationLabel.bounds.size.height/2
        classificationLabel.layer.masksToBounds = true
        classificationLabel.clipsToBounds = true
        classificationLabel.backgroundColor = .yellow
        photo.image = self.image
        updateClassifications(for: photo.image!)
        // Do any additional setup after loading the view.
    }
    
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            /*
             Use the Swift class `MobileNet` Core ML generates from the model.
             To use a different Core ML classifier model, add it to the project
             and replace `MobileNet` with that model's generated Swift class.
             */
            let model = try VNCoreMLModel(for: Resnet50().model)
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                print("hello")
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    func updateClassifications(for image: UIImage) {
        classificationLabel.text = "Classifying..."
        
        let orientation = image.imageOrientation
        let newOrientation = CGImagePropertyOrientation(orientation)
        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: newOrientation)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                /*
                 This handler catches general image processing errors. The `classificationRequest`'s
                 completion handler `processClassifications(_:error:)` catches errors specific
                 to processing that request.
                 */
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            print("hello2")
            guard let results = request.results else {
                self.classificationLabel.text = "Unable to classify image.\n\(error!.localizedDescription)"
                return
            }
            print("hello3")

            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            let classifications = results as! [VNClassificationObservation]
        
            if classifications.isEmpty {
                print("hello4")

                self.classificationLabel.text = "Nothing recognized."
            } else {
                print("hello5")
                //print(classifications)
                // Display top classifications ranked by confidence in the UI.
                let topClassifications = classifications.prefix(1)
                let descriptions = topClassifications.map { classification in
                    // Formats the classification for display; e.g. "(0.37) cliff, drop, drop-off".
                   return String(classification.identifier)
                }
                self.classificationLabel.text = "Food item: " + descriptions.joined(separator: "\n")
                self.sfood = descriptions[0]
                print(descriptions[0])
            }
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nutritionFactsSegue" {
            let vc = segue.destination as! NutritionFactsViewController
            vc.food = self.sfood
            vc.upperDataInterface = self
        }
    }
    
    @IBAction func yesButton(_ sender: Any) {
        performSegue(withIdentifier: "nutritionFactsSegue", sender: nil)
    }
    
    @IBAction func noButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension PreviewViewController: dataInterface {
    func dismissCameraView() {
        dismiss(animated: true, completion: nil)
        upperDataInterface?.dismissCameraView()
    }
    
    func passDataBack(data: NSDictionary) {
        upperDataInterface?.passDataBack(data: data)
    }
}
