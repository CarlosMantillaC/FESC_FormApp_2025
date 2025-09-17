//
//  FormViewProtocol.swift
//  FormApp
//
//  Created by Gopenux on 17/09/25.
//

import Foundation

protocol FormViewProtocol: AnyObject {
    func showValidationError(_ message: String)
    func showSuccess()
}
