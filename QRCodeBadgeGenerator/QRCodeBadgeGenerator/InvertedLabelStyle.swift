//
//  InvertedLabelStyle.swift
//  QRCodeBadgeGenerator
//
//  Created by Sharan Thakur on 16/10/24.
//

import SwiftUI

struct InvertedLabelStyle: LabelStyle {
    var flipImage: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center, spacing: 10) {
            configuration.title
            
            configuration.icon
                .scaleEffect(x: flipImage ? -1 : 1)
        }
    }
}

#Preview("Testing Label Style", body: {
    Label("Label", systemImage: "moon.stars")
        .labelStyle(InvertedLabelStyle(flipImage: true))
})
