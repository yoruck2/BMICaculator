//
//  ViewController.swift
//  BMICaculator
//
//  Created by dopamint on 5/21/24.
//

import UIKit

class ViewController: UIViewController {
    

    var userBMI: Float = 0
    var obesityIndex: BMIRange?
    let validRange:  ClosedRange<Float> = 10...300
    
    @IBOutlet var mainTitleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var heightTextField: UITextField!
    @IBOutlet var weightTextField: UITextField!
    
    @IBOutlet var resultButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextField(heightTextField)
        setUpTextField(weightTextField)
        setUpDescriptionLabel()
        setUpSecureButton()
        setUpresultButton()
        
    }
    
    @IBAction func tapForKeyboardDismiss(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func resultButtonTapped(_ sender: UIButton) {
        calculateBMI()
        //alert
    }
    
    @IBAction func randomBMIbutton(_ sender: UIButton) {
        heightTextField.text = String(Int.random(in: 20...250))
        weightTextField.text = String(Int.random(in: 1...250))
        calculateBMI()
    }
    
    @objc 
    func toggleTextSecurity() {
        weightTextField.isSecureTextEntry.toggle()
        (weightTextField.rightView as? UIButton)?.isSelected.toggle()
    }
    
    func calculateBMI() {
        
        let height = validateValue(value: heightTextField)
        let weight = validateValue(value: weightTextField)
        userBMI = weight / pow(height/100, 2)
        userBMI = round(userBMI * 10) / 10
        
        switch userBMI {
            
        case 0...18.5:
            obesityIndex = .underweight
        case 18.5...22.9:
            obesityIndex = .normal
        case 23.0...24.9:
            obesityIndex = .overweight
        case 25...:
            obesityIndex = .obesity
        default:
            break
        }
        showBMI(obesityIndex: obesityIndex?.rawValue)
    }
    
    func validateValue(value: UITextField?) -> Float {
        if value?.text == "" && value?.tag == 0 {
            showInvalidValueAlert("키를 입력해 주세요")
        } else if value?.text == "" && value?.tag == 1 {
            showInvalidValueAlert("몸무게를 입력해 주세요")
        }
        
        guard let text = value?.text, let result = Float(text) else {
            showInvalidValueAlert("숫자만 입력해 주세요")
            // 이게 왜되지
            value?.text = ""
            return 0
        }
        
        guard validRange ~= result else {
            showInvalidValueAlert("1 ~ 300 사이의 값만 입력 가능합니다")
            value?.text = ""
            return 0
        }
        return result
    }
    
    func showBMI(obesityIndex: String?) {
        guard let obesityIndex else {
            return
        }
        
        let showBMI = UIAlertController(title: "당신의 BMI",
                                        message: "당신의 BMI는 \(userBMI)입니다./n\(obesityIndex) 이시네요!",
                                        preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인",
                                    style: .default)
        
        showBMI.addAction(confirm)
        present(showBMI, animated: true)
    }
    
    func showInvalidValueAlert(_ message: String) {
        let invalidValueAlert = UIAlertController(title: "계산실패",
                                                  message: "\(message)",
                                                  preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인",
                                    style: .default)
        
        invalidValueAlert.addAction(confirm)
        present(invalidValueAlert, animated: true)
    }
}

extension ViewController {
    
    func setUpDescriptionLabel() {
        descriptionLabel.text = "당신의 BMI 지수를\n알려드릴게요"
    }
    
    func setUpTextField(_ textField: UITextField) {
        textField.layer.cornerRadius = 15
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.gray.cgColor
    }
    
    func setUpresultButton() {
        resultButton.layer.cornerRadius = 15
    }
    
    func setUpSecureButton() {
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.imagePadding = 8
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        button.setImage(UIImage(systemName: "eye.slash.fill"), for: .selected)
        button.addTarget(self, action: #selector(toggleTextSecurity), for: .touchUpInside)
        button.tintColor = .lightGray
        button.configuration = buttonConfiguration
        
        weightTextField.rightView = button
        weightTextField.rightViewMode = .always
    }
}

enum BMIRange: String {

    case underweight = "저체중"
    case normal = "정상"
    case overweight = "과체중"
    case obesity = "비만"
    
    var range: ClosedRange<Float> {
        switch self {
        case .underweight:
            return 0...18.5
        case .normal:
            return 18.5...22.9
        case .overweight:
            return 23.0...24.9
        case .obesity:
            return 25...99999
        }
    }
}
