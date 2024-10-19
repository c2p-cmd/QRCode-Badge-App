//
//  ContentView.swift
//  QRCodeBadgeGenerator
//
//  Created by Sharan Thakur on 16/10/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isPresented = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Rectangle()
                    .fill(Color.BG.gradient)
                    .ignoresSafeArea(.all)
                
                VStack(spacing: 20) {
                    Image(.appIcon)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(.rect(cornerRadius: 20, style: .continuous))
                    
                    headingView
                        .padding()
                    
                    NavigationLink(destination: FormView()) {
                        Label("Generate Badge", systemImage: "qrcode")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.teal)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
        }
    }
    
    var headingView: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("Welcome to \"Badgey\" QRCode Generator!")
                .font(.title2)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .multilineTextAlignment(.center)
            
            Text("Simply Fill in the Details and Press Generate to get your personalized Badge with a QR Code")
                .font(.headline)
                .fontWeight(.medium)
                .fontDesign(.rounded)
                .padding(.horizontal)
        }
    }
}

#Preview {
    ContentView()
}
