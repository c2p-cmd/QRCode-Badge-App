//
//  AppError.swift
//  QRCodeBadgeGenerator
//
//  Created by Sharan Thakur on 16/10/24.
//

import Foundation

enum AppError: LocalizedError, CustomStringConvertible {
    case invalidInput(String?)
    case failedToGenerateImage
    case custom(String)
    
    var errorDescription: String? { description }
    
    var description: String {
        switch self {
        case .invalidInput(let description):
            if let description {
                return "Invalid input: \(description)"
            } else {
                return "Invalid input"
            }
        case .failedToGenerateImage:
            return "Faile to generate image"
        case .custom(let message):
            return message
        }
    }
}
