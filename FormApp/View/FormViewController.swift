//
//  FormViewController.swift
//  FormApp
//
//  Created by Gopenux on 17/09/25.
//

import UIKit

class FormViewController: UIViewController, FormViewProtocol {
    private var presenter: FormPresenter!
    private let fullNameTextField = UITextField()
    private let emailTextField = UITextField()
    private let phoneTextField = UITextField()
    private let companyTextField = UITextField()
    private let jobTitleTextField = UITextField()
    private let countryPicker = UIPickerView()
    private let messageTextView = UITextView()
    private let termsSwitch = UISwitch()
    private let submitButton = UIButton(type: .system)
    
    let countries = ["Seleccione", "Colombia", "México", "Argentina", "Chile", "Otro"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = FormPresenter(view: self)
        
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [
            labeledField("Nombre completo", fullNameTextField),
            labeledField("Email", emailTextField),
            labeledField("Teléfono", phoneTextField),
            labeledField("Empresa", companyTextField),
            labeledField("Cargo", jobTitleTextField),
            labeledPicker("País", countryPicker),
            labeledTextView("Mensaje", messageTextView),
            labeledSwitch("Aceptar términos", termsSwitch),
            submitButton
        ])
        
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        [fullNameTextField, emailTextField, phoneTextField, companyTextField, jobTitleTextField].forEach {
            $0.borderStyle = .roundedRect
        }
        phoneTextField.keyboardType = .numberPad
        
        messageTextView.layer.borderColor = UIColor.gray.cgColor
        messageTextView.layer.borderWidth = 1
        messageTextView.layer.cornerRadius = 6
        messageTextView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        countryPicker.dataSource = self
        countryPicker.delegate = self
        
        submitButton.setTitle("Enviar", for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
    }
    
    private func labeledField(_ label: String, _ textField: UITextField) -> UIStackView {
        let l = UILabel()
        l.text = label
        let stack = UIStackView(arrangedSubviews: [l, textField])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }
    
    private func labeledPicker(_ label: String, _ picker: UIPickerView) -> UIStackView {
        let l = UILabel()
        l.text = label
        let stack = UIStackView(arrangedSubviews: [l, picker])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }
    
    private func labeledTextView(_ label: String, _ textView: UITextView) -> UIStackView {
        let l = UILabel()
        l.text = label
        let stack = UIStackView(arrangedSubviews: [l, textView])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }
    
    private func labeledSwitch(_ label: String, _ uiSwitch: UISwitch) -> UIStackView {
        let l = UILabel()
        l.text = label
        let stack = UIStackView(arrangedSubviews: [l, uiSwitch])
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }
    
    @objc private func submitTapped() {
        let selectedCountry = countries[countryPicker.selectedRow(inComponent: 0)]
        
        let form = FormModel(
            fullName: fullNameTextField.text ?? "",
            email: emailTextField.text ?? "",
            phone: phoneTextField.text ?? "",
            company: companyTextField.text ?? "",
            jobTitle: jobTitleTextField.text ?? "",
            country: selectedCountry,
            message: messageTextView.text ?? "",
            termsAccepted: termsSwitch.isOn
        )
        
        presenter.validateForm(form)
    }
    
    func showValidationError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showSuccess() {
        let alert = UIAlertController(title: "Éxito", message: "Formulario enviado correctamente", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension FormViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row]
    }
}
