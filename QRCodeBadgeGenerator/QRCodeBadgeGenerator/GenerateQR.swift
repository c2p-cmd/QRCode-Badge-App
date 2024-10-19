//
//  GenerateQR.swift
//  QRCodeBadgeGenerator
//
//  Created by Sharan Thakur on 16/10/24.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import UIKit

enum QRCodeBadge {
    enum CorrectionLevel: String, CaseIterable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
        case quartile = "Quartile"
    }
    
    static private let context = CIContext()
    
    /// Method to generate QRCode as ``UIImage`` from `JSON` encoded ``Data``
    /// - Parameters:
    ///   - data: `JSON` encoded ``Data`` object holding details to be shown
    ///   - scale: Value to scale the output by, defaults to 1
    ///   - correctionLevel: Optional `QR Error Correction Level`, default `nil`
    /// - Returns: ``UIImage`` if possible
    static func generate(data: Data, scaledBy scale: CGFloat = 1, correctionLevel: CorrectionLevel? = nil) -> UIImage? {
        let filter = CIFilter.qrCodeGenerator()
        filter.message = data
        if let correctionLevel {
            filter.correctionLevel = correctionLevel.rawValue
        }
        
        if let outputCIImage = filter.outputImage?.transformed(by: CGAffineTransform(scaleX: scale, y: scale)),
           let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        
        return nil
    }
}
