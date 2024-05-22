//
//  ViewController.swift
//  BMICaculator
//
//  Created by dopamint on 5/21/24.
//

import UIKit

class ViewController: UIViewController {
    
    var userNickname: String?
    var userHeight: String?
    var userWeight: String?
    var userBMI: Float = 0
    var obesityIndex: BMIRange?
    let validRange:  ClosedRange<Float> = 10...300
    let userDefaults = UserDefaults.standard
    
    @IBOutlet var mainTitleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var nicknameTextField: UITextField!
    @IBOutlet var heightTextField: UITextField!
    @IBOutlet var weightTextField: UITextField!
    
    @IBOutlet var resultButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextField(nicknameTextField)
        setUpTextField(heightTextField)
        setUpTextField(weightTextField)
        setUpDescriptionLabel()
        setUpSecureButton()
        setUpResultButton()
    }
    
    @IBAction func nicknameTextFiedlChanged(_ sender: UITextField) {
        guard let nickname = sender.text else {
            return
        }
        
        if nickname == "" {
            descriptionLabel.text = "당신의 BMI 지수를\n알려드릴게요"
            return
        }
        descriptionLabel.text = "\(nickname)님의 BMI 지수를\n알려드릴게요"
    }
    
    @IBAction func tapForKeyboardDismiss(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func resultButtonTapped(_ sender: UIButton) {
        calculateBMI()
        
        let textFieldValues = [userNickname, userHeight, userWeight]
        if !textFieldValues.contains(nil) {
            userDefaults.set(textFieldValues, forKey: "textFieldValues")
            showBMI(obesityIndex: obesityIndex?.rawValue)
        }
    }
    
    @IBAction func randomBMIbutton(_ sender: UIButton) {
        heightTextField.text = String(Int.random(in: 20...250))
        weightTextField.text = String(Int.random(in: 1...250))
        calculateBMI()
        showBMI(obesityIndex: obesityIndex?.rawValue)
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        showResetAlert()
    }
    
    @objc
    func toggleTextSecurity() {
        weightTextField.isSecureTextEntry.toggle()
        (weightTextField.rightView as? UIButton)?.isSelected.toggle()
    }
    
    func calculateBMI() {
        validateValue(textField: nicknameTextField)
        let height = validateValue(textField: heightTextField)
        guard height != 0 else {
            return
        }
        
        let weight = validateValue(textField: weightTextField)
        guard weight != 0 else {
            return
        }
        
        userNickname = nicknameTextField.text
        userHeight = String(Int(height))
        userWeight = String(Int(weight))
        userBMI = weight / pow(height/100, 2)
        userBMI = round(userBMI * 10) / 10
        
        switch userBMI {
            
        case BMIRange.underweight.range:
            obesityIndex = .underweight
        case BMIRange.normal.range:
            obesityIndex = .normal
        case BMIRange.overweight.range:
            obesityIndex = .overweight
        case BMIRange.obesity.range:
            obesityIndex = .obesity
        default:
            break
        }
    }
    
    @discardableResult
    func validateValue(textField: UITextField?) -> Float {
        
        guard let text = textField?.text else {
            return 0
        }
        
        if text == "" {
            switch textField?.tag {
            case 0:
                showInvalidValueAlert("이름을 입력해 주세요")
            case 1:
                showInvalidValueAlert("키를 입력해 주세요")
            case 2:
                showInvalidValueAlert("몸무게를 입력해 주세요")
            default:
                break
            }
            return 0
        }
        
        if textField?.tag == 0 {
            userNickname = text
            return 0
        }
        
        guard let result = Float(text) else {
            showInvalidValueAlert("숫자만 입력해 주세요")
            textField?.text = ""
            return 0
        }
        
        guard validRange ~= result else {
            showInvalidValueAlert("1 ~ 300 사이의 값만 입력 가능합니다")
            textField?.text = ""
            return 0
        }
        return result
    }
    
    func showBMI(obesityIndex: String?) {
        guard let obesityIndex else {
            return
        }
        
        let showBMI = UIAlertController(title: "계산 결과",
                                        message: "\n\(userNickname ?? "")님의 BMI는 \(userBMI)입니다.\n\(obesityIndex) 이시네요!",
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
    
    func showResetAlert() {
        
        let resetAlert = UIAlertController(title: "정보 초기화",
                                           message: "모든 정보를 초기화 할래요?",
                                           preferredStyle: .alert)
        let confirm = UIAlertAction(title: "네",
                                    style: .destructive) { action in
            self.nicknameTextField.text = ""
            self.heightTextField.text = ""
            self.weightTextField.text = ""
            self.userDefaults.removeObject(forKey: "textFieldValues")
            self.setUpDescriptionLabel()
        }
        let deny = UIAlertAction(title: "아니요",style: .cancel)
        
        resetAlert.addAction(confirm)
        resetAlert.addAction(deny)
        present(resetAlert, animated: true)
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
        
        //        if userHeight != nil {
        textField.text =  userDefaults.stringArray(forKey: "textFieldValues")?[textField.tag]
        //        }
    }
    
    func setUpResultButton() {
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

