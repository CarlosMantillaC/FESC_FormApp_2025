//
//  FormPresenter.swift
//  FormApp
//
//  Created by Gopenux on 17/09/25.
//

import Foundation

class FormPresenter {
    weak var view: FormViewProtocol?
    
    init(view: FormViewProtocol) {
        self.view = view
    }
    
    func validateForm(_ form: FormModel) {
        guard !form.fullName.isEmpty,
              !form.email.isEmpty,
              !form.phone.isEmpty,
              !form.company.isEmpty,
              !form.jobTitle.isEmpty,
              !form.country.isEmpty else {
            view?.showValidationError("Todos los campos son requeridos")
            return
        }
        
        let nameRegex = "^[A-Za-zÁÉÍÓÚÑáéíóúñ ]+$"
        if !NSPredicate(format: "SELF MATCHES %@", nameRegex).evaluate(with: form.fullName) {
            view?.showValidationError("El nombre solo puede contener letras y espacios")
            return
        }
        
        if !isValidCorporateEmail(form.email) {
            view?.showValidationError("Ingrese un email corporativo válido")
            return
        }
        
        let phoneRegex = "^[0-9]{10}$"
        if !NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: form.phone) {
            view?.showValidationError("El teléfono debe tener 10 dígitos numéricos")
            return
        }
        
        if form.message.count > 500 {
            view?.showValidationError("El mensaje no puede superar los 500 caracteres")
            return
        }
        
        if form.message.contains("<script>") {
            view?.showValidationError("Entrada inválida en el mensaje")
            return
        }
        
        if form.country == "Seleccione" {
            view?.showValidationError("Debe seleccionar un país")
            return
        }
        
        if !form.termsAccepted {
            view?.showValidationError("Debe aceptar los términos")
            return
        }
        
        view?.showSuccess()
    }
    
    private func isValidCorporateEmail(_ email: String) -> Bool {
        let regex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.(?!gmail|yahoo|hotmail)([A-Za-z]{2,})$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
}
