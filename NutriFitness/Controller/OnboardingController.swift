import UIKit

class OnboardingController: UIViewController {
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var dismissButton: UIButton!
    var baseMetabolicRate = 0
    var caloriesToLive = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissButton.backgroundColor = .gray
        dismissButton.layer.cornerRadius = 20
        dismissButton.clipsToBounds = true
        dismissButton.layer.masksToBounds = true
        
        
        
        
    }
    @IBAction func dismissButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true) {
            print("dismissed")
        }
    }
}
