//
//  DetailsModel.swift
//  QRCodeBadgeGenerator
//
//  Created by Sharan Thakur on 16/10/24.
//

import SwiftUI

struct PersonalDetails: Identifiable, Hashable, CustomStringConvertible {
    let id = UUID()
    var name: String = ""
    var emailAddress: String = ""
    var twitterHandle: String = ""
    var githubHandle: String = ""
    
    var description: String {
        "\(name)\n\(emailAddress)\n\(twitterHandle)\n\(githubHandle)"
    }
}

/// Codable Extensions
extension PersonalDetails {
    /// Method to encode as data
    /// - Returns: ``Data``
    func asData() -> Data {
        Data(self.description.utf8)
    }
}

struct Photo: Identifiable, Transferable {
    let id = UUID()
    let image: Image
    let qrImage: Image
    
    init(image: Image, qrImage: Image) {
        self.image = image
        self.qrImage = qrImage
    }
    
    init(uiImage: UIImage, qrUIImage: UIImage) {
        self.image = Image(uiImage: uiImage)
        self.qrImage = Image(uiImage: qrUIImage)
    }
    
    static var transferRepresentation: some TransferRepresentation {
        ProxyRepresentation(exporting: \.image)
    }
    
    var sharePreview: SharePreview<Image, Never> {
        SharePreview("QRBadge", image: self.image)
    }
}
