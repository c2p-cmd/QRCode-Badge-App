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
            VStack(spacing: 20) {
                Spacer()
                
                headingView
                
                Spacer()

                
                Button("Generate Badge", systemImage: "qrcode") {
                    withAnimation {
                        isPresented.toggle()
                    }
                }
                .tint(.teal)
                .font(.title3.bold())
                .buttonStyle(.borderedProminent)
                .labelStyle(InvertedLabelStyle())
                .sheet(isPresented: $isPresented, content: FormView.init)
                
                Spacer()
                    .frame(height: 100)
            }
            .padding()
        }
    }
    
    var headingView: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("Welcome to Badgey\nQRCode Generator!")
                .font(.title)
                .fontWeight(.semibold)
                .fontDesign(.monospaced)
            
            Text("Simply Fill in the Details and Press Generate to get your Badge")
                .font(.headline)
                .fontWeight(.medium)
                .fontDesign(.monospaced)
        }
    }
}

#Preview {
    ContentView()
}
