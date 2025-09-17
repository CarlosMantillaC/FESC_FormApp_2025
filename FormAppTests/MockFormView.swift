//
//  MockFormView.swift
//  FormAppTests
//
//  Created by Gopenux on 17/09/25.
//

import Foundation
@testable import FormApp

class MockFormView: FormViewProtocol {
    var lastError: String?
    var successShown = false
    
    func showValidationError(_ message: String) {
        lastError = message
    }
    
    func showSuccess() {
        successShown = true
    }
}
