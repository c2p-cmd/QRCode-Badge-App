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
    /// Method to generate QRCode as ``UIImage`` from `JSON` encoded ``Data``
    /// - Parameters:
    ///   - data: `JSON` encoded ``Data`` object holding details to be shown
    ///   - scale: Value to scale the output by, defaults to 1
    /// - Returns: ``UIImage`` if possible
    static func generate(data: Data, scaledBy scale: CGFloat = 1) -> UIImage? {
        let filter = CIFilter.qrCodeGenerator()
        filter.message = data
        
        print(filter.inputKeys)
        
        if let outputCIImage = filter.outputImage?.transformed(by: CGAffineTransform(scaleX: scale, y: scale)) {
            return UIImage(ciImage: outputCIImage)
        }
        
        return nil
    }
}
