//
//  FormView.swift
//  QRCodeBadgeGenerator
//
//  Created by Sharan Thakur on 16/10/24.
//

import SwiftUI

struct FormView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var vm = ViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                inputSection
                
                buttonsSection
            }
            .alert(isPresented: $vm.showError, error: vm.error) { _ in
            } message: { error in
                Text(error.localizedDescription)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Details")
        }
    }
    
    var inputSection: some View {
        Section {
            textField(
                $vm.details.name,
                placeholder: Text("Name")
            )
            .submitLabel(.next)
            
            textField(
                $vm.details.emailAddress,
                placeholder: Text("Email Address")
            )
            .submitLabel(.next)
            
            textField(
                $vm.details.twitterHandle,
                placeholder: Text("Twitter Handle"),
                required: false
            )
            .submitLabel(.next)
            textField(
                $vm.details.githubHandle,
                placeholder: Text("GitHub Handle"),
                required: false
            )
            .submitLabel(.done)
        }
        .onSubmit(vm.submit)
    }
    
    var buttonsSection: some View {
        Section {
            HStack {
                Button("Cancel", role: .destructive, action: dismiss.callAsFunction)
                
                Spacer()
                Divider()
                Spacer()
                
                Button("Create", systemImage: "wand.and.stars", action: vm.submit)
                    .labelStyle(InvertedLabelStyle(flipImage: true))
            }
            .buttonStyle(.borderless)
        }
    }
    
    func textField(_ binding: Binding<String>, placeholder: Text?, required: Bool = true) -> some View {
        VStack(alignment: .leading, spacing: 7.5) {
            TextField(text: binding, prompt: placeholder, axis: .horizontal) {
                placeholder
            }
            
            Group {
                if required {
//                    Label("Required", systemImage: "exclamationmark.triangle.fill")
                    Text("Required")
                        .foregroundStyle(.secondary)
                } else {
                    Text("Optional")
                        .foregroundStyle(.secondary)
                }
            }
            .font(.caption)
        }
    }
}

extension FormView {
    final class ViewModel {
        var details: PersonalDetails = .empty
        
        var error: AppError?
        
        var showError: Bool {
            get { error != nil }
            set { error = nil }
        }
        
        func submit() {
            if details.name.isEmpty {
                error = .invalidInput("Name is required")
            }
            if details.emailAddress.isEmpty {
                error = .invalidInput("Email address is required")
            }
            if !details.twitterHandle.hasPrefix("@") {
                error = .invalidInput("Twitter handle must start with a '@'")
            }
        }
        
        func isValid(email emailAddress: String) -> Bool {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailPred.evaluate(with: emailAddress)
        }
    }
}

#Preview {
    FormView()
}
