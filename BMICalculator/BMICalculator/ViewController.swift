import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var heightInput: UITextField!
    @IBOutlet weak var heightInchesInput: UITextField!
    @IBOutlet weak var weightInput: UITextField!
    @IBOutlet weak var switchUnit: UISwitch!
    @IBOutlet weak var BMIOutput: UILabel!
    @IBOutlet weak var BMICategory: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        heightInchesInput.isHidden = true
        clearOutputs() // Clear outputs when the view loads
    }

    @IBAction func switchAction(_ sender: UISwitch) {
        if switchUnit.isOn {
            // Switch to metric units
            heightInput.placeholder = "cm"
            heightInchesInput.isHidden = true
            weightInput.placeholder = "kilograms"
            clearInputs()
        } else {
            // Switch to imperal units
            heightInput.placeholder = "feet"
            heightInchesInput.isHidden = false
            heightInchesInput.placeholder = "inches"
            weightInput.placeholder = "pounds"
            clearInputs()
        }
        clearOutputs() // Clear output when we swtich units
    }

    @IBAction func calculateBMIButton(_ sender: UIButton) {
        // Reset previous output
        BMIOutput.text = "BMI is"
        BMICategory.text = "BMI Category"
        
        // Input vlaidation
        guard let weightText = weightInput.text, !weightText.isEmpty,
              let weight = Double(weightText), weight > 0 else {
            showError(message: "Please enter a valid weight.")
            return
        }

        var heightInMeters: Double = 0.0
        
        if switchUnit.isOn {
            // Metric system
            guard let heightText = heightInput.text, !heightText.isEmpty,
                  let height = Double(heightText), height > 0 else {
                showError(message: "Please enter a valid height in centimeters.")
                return
            }
            heightInMeters = height / 100 // Convert cm to meters
        } else {
            // Imperial system
            guard let feetText = heightInput.text, !feetText.isEmpty,
                  let feet = Double(feetText),
                  let inchesText = heightInchesInput.text, !inchesText.isEmpty,
                  let inches = Double(inchesText), inches >= 0 && inches < 12 else {
                showError(message: "Please enter a valid height (feet and inches).")
                return
            }
            heightInMeters = (feet * 12 + inches) * 0.0254 // Convert feet and inches to meters
        }

        let bmi = weight / (heightInMeters * heightInMeters)
        BMIOutput.text = String(format: "BMI is %.2f", bmi)
        BMICategory.text = bmiCategory(bmi)
    }

    
    //function to clear inputs
    private func clearInputs() {
        heightInput.text = ""
        heightInchesInput.text = ""
        weightInput.text = ""
    }

    //function to clear output
    private func clearOutputs() {
        BMIOutput.text = "BMI is"
        BMICategory.text = "BMI Category"
    }

    private func showError(message: String) {
        BMIOutput.text = message // Display error in BMIOutput
        BMICategory.text = "" // Clear the BMI category label
    }

    private func bmiCategory(_ bmi: Double) -> String {
        switch bmi {
        case let x where x < 18.5:
            return "Underweight"
        case 18.5..<24.9:
            return "Normal weight"
        case 25..<29.9:
            return "Overweight"
        default:
            return "Obesity"
        }
    }
}

