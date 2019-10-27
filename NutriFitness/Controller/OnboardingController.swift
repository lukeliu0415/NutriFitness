import UIKit

class OnboardingController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    
    
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet var pickerView: UIPickerView! = UIPickerView()
    let defaults = UserDefaults.standard
    var gender = ["Male", "Female", "Prefer Not To Say"]
    var age: [Int] = []
    var height: [Int] = []
    var weight: [Int] = []

    
    var baseMetabolicRate = 0
    var caloriesToLive = 0
    override func viewDidLoad() {
        
        super.viewDidLoad()
//        dismissButton.backgroundColor = .gray
//        dismissButton.layer.cornerRadius = 20
//        dismissButton.clipsToBounds = true
//        dismissButton.layer.masksToBounds = true
        for x in 0 ..< 200 {
            age.append(x+1)
        }
        for x in 0 ..< 300 {
            height.append(x+1)
            weight.append(x+1)
        }
        genderTextField.text = gender[1]
        ageTextField.text = String(age[16])
        heightTextField.text = String(height[179])
        weightTextField.text = String(weight[60])
        genderTextField.delegate = self
        ageTextField.delegate = self
        heightTextField.delegate = self
        weightTextField.delegate = self
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.isHidden = true
    
    }
    var selected = 0
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField == ageTextField) {
            selected = 1
        } else if(textField == genderTextField){
            selected = 0
        } else if(textField == heightTextField){
            selected = 2
        } else {
            selected = 3
        }
        pickerView.reloadAllComponents()
        pickerView.isHidden = false
        return false
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if (selected == 1) {
            return age.count
        }
        else if (selected == 0){
            return gender.count
        }
        else if (selected == 2) {
            return height.count
        } else {
            return weight.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (selected == 1) {
            return String(age[row])
        }
        else if (selected == 0){
            return gender[row]
        }
        else if (selected == 2) {
            return String(height[row])
        } else {
            return String(weight[row])
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if (selected == 1) {
            ageTextField.text = String(age[row])
        }
        else if (selected == 0) {
            genderTextField.text = gender[row]
        }
        else if (selected == 2) {
            heightTextField.text = String(height[row])
        } else {
            weightTextField.text = String(weight[row])
        }
        pickerView.isHidden = true;
    }
    @IBAction func dismissButtonPressed(_ sender: UIButton) {
        guard let weightText = weightTextField.text else {
            return
        }
        guard let ageText = ageTextField.text else {
            return
        }
        guard let heightText = heightTextField.text else {
            return
        }
        guard let genderText = genderTextField.text else {
            return
        }
        self.dismiss(animated: true) {
            print("dismissed")
            var baseMetabolicRate: Double = 0
            var BMR2: Double = 0

            if(self.genderTextField.text == "Male") {
                baseMetabolicRate = 66.4730 + (13.7516 * Double(weightText)!)
                BMR2 = (5.0033 * Double(heightText)! - (6.7550 * Double(ageText)!))
                
            } else if(self.genderTextField.text == "Female"){
                baseMetabolicRate = 655.0955 + (9.5634 * Double(weightText)!)
                BMR2 = (1.8496 * Double(heightText)!) - (4.6756 * Double(ageText)!)
            } else {
                baseMetabolicRate = 300.4730 + (11.7516 * Double(weightText)!)
                BMR2 = (3.0033 * Double(heightText)!) - (5.5 * Double(ageText)!)
            }
            var BMR = baseMetabolicRate + BMR2
            BMR.round()
            print(BMR)
            self.defaults.set(BMR, forKey: "BMR")
            

        }
    }
}
