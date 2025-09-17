//
//  FormAppTests.swift
//  FormAppTests
//
//  Created by Gopenux on 17/09/25.
//

import XCTest
@testable import FormApp

final class FormPresenterTests: XCTestCase {
    
    var presenter: FormPresenter!
    var mockView: MockFormView!
    
    override func setUp() {
        super.setUp()
        mockView = MockFormView()
        presenter = FormPresenter(view: mockView)
    }

    override func tearDown() {
        presenter = nil
        mockView = nil
        super.tearDown()
    }
    
    func testEmptyFields_TC01() {
        let form = FormModel(fullName: "", email: "", phone: "", company: "", jobTitle: "", country: "", message: "", termsAccepted: false)
        presenter.validateForm(form)
        XCTAssertEqual(mockView.lastError, "Todos los campos son requeridos")
    }
    
    func testInvalidName_TC02() {
        let form = FormModel(fullName: "123456!", email: "user@empresa.com", phone: "1234567890", company: "ACME", jobTitle: "Dev", country: "Colombia", message: "Hola", termsAccepted: true)
        presenter.validateForm(form)
        XCTAssertEqual(mockView.lastError, "El nombre solo puede contener letras y espacios")
    }
    
    func testInvalidEmailFormat_TC03() {
        let form = FormModel(fullName: "Carlos", email: "sin@_", phone: "1234567890", company: "ACME", jobTitle: "Dev", country: "Colombia", message: "Hola", termsAccepted: true)
        presenter.validateForm(form)
        XCTAssertEqual(mockView.lastError, "Ingrese un email corporativo válido")
    }

    func testInvalidPhone_TC05() {
        let form = FormModel(fullName: "Carlos", email: "user@empresa.com", phone: "123", company: "ACME", jobTitle: "Dev", country: "Colombia", message: "Hola", termsAccepted: true)
        presenter.validateForm(form)
        XCTAssertEqual(mockView.lastError, "El teléfono debe tener 10 dígitos numéricos")
    }
    
    func testMessageExceedsLimit_TC06() {
        let longMessage = String(repeating: "a", count: 501)
        let form = FormModel(fullName: "Carlos", email: "user@empresa.com", phone: "1234567890", company: "ACME", jobTitle: "Dev", country: "Colombia", message: longMessage, termsAccepted: true)
        presenter.validateForm(form)
        XCTAssertEqual(mockView.lastError, "El mensaje no puede superar los 500 caracteres")
    }
    
    func testMessageWithScript_TC07() {
        let form = FormModel(fullName: "Carlos", email: "user@empresa.com", phone: "1234567890", company: "ACME", jobTitle: "Dev", country: "Colombia", message: "<script>alert()</script>", termsAccepted: true)
        presenter.validateForm(form)
        XCTAssertEqual(mockView.lastError, "Entrada inválida en el mensaje")
    }
    
    func testCountryNotSelected_TC08() {
        let form = FormModel(fullName: "Carlos", email: "user@empresa.com", phone: "1234567890", company: "ACME", jobTitle: "Dev", country: "Seleccione", message: "Hola", termsAccepted: true)
        presenter.validateForm(form)
        XCTAssertEqual(mockView.lastError, "Debe seleccionar un país")
    }
    
    func testSuccessfulSubmit_TC09() {
        let form = FormModel(fullName: "Carlos", email: "user@empresa.com", phone: "1234567890", company: "ACME", jobTitle: "Dev", country: "Colombia", message: "Hola", termsAccepted: true)
        presenter.validateForm(form)
        XCTAssertTrue(mockView.successShown)
    }
}
