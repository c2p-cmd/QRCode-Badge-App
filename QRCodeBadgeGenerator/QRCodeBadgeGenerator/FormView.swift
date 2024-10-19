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
    @FocusState private var focusField: FocusField?
    
    enum FocusField {
        case name, email, twitter, github
    }
    
    var body: some View {
        Form {
            inputSection
                .disabled(vm.isBusy)
            
            buttonsSection
                .disabled(vm.isBusy)
            
            if vm.isBusy {
                VStack {
                    ProgressView()
                    Text("Generating...")
                }
            }
        }
        .sheet(item: $vm.resultImage) { resultPhoto in
            OutputView(details: vm.details, resultPhoto: resultPhoto)
        }
        .alert(isPresented: $vm.showError, error: vm.error) { _ in
        } message: { err in
            Text(err.errorDescription ?? err.localizedDescription)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Details")
    }
    
    var inputSection: some View {
        Section {
            textField(
                $vm.details.name,
                placeholder: Text("Name"),
                focusField: .name,
                submitLabel: .next
            ) {
                self.focusField = .email
            }
            .textContentType(.name)
            
            textField(
                $vm.details.emailAddress,
                placeholder: Text("Email Address"),
                focusField: .email,
                submitLabel: .next
            ) {
                self.focusField = .twitter
            }
            .textContentType(.emailAddress)
            
            textField(
                $vm.details.twitterHandle,
                placeholder: Text("Twitter Handle"),
                focusField: .twitter,
                required: false,
                submitLabel: .next
            ) {
                self.focusField = .github
            }
            .textContentType(.username)
            
            textField(
                $vm.details.githubHandle,
                placeholder: Text("GitHub Handle"),
                focusField: .github,
                required: false,
                submitLabel: .done
            ) {
                self.focusField = nil
                vm.submit()
            }
            .textContentType(.username)
        }
    }
    
    var buttonsSection: some View {
        Section {
            Button("Cancel", role: .destructive, action: dismiss.callAsFunction)
            
            Button("Create", systemImage: "wand.and.stars") {
                self.focusField = nil
                vm.submit()
            }
        }
    }
    
    func textField(
        _ binding: Binding<String>,
        placeholder: Text?,
        focusField: FocusField,
        required: Bool = true,
        submitLabel: SubmitLabel = .done,
        onSubmit: @escaping () -> Void
    ) -> some View {
        VStack(alignment: .leading, spacing: 7.5) {
            TextField(text: binding, prompt: placeholder, axis: .horizontal) {
                placeholder
            }
            .focused($focusField, equals: focusField)
            .submitLabel(submitLabel)
            .onSubmit(onSubmit)
            
            Group {
                if required {
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
    @Observable
    final class ViewModel {
        var details = PersonalDetails()
        var resultImage: Photo?
        var error: AppError?
        var showError = false
        var isBusy = false
        
        func submit() {
#if targetEnvironment(simulator)
            self.details = PersonalDetails(
                name: "John Doe",
                emailAddress: "john@doe.com",
                twitterHandle: "@johndoe",
                githubHandle: "johnsnow"
            )
#endif
            guard !details.name.isEmpty else {
                error = .invalidInput("Name is required")
                self.showError = true
                return
            }
            guard !details.emailAddress.isEmpty else {
                error = .invalidInput("Email address is required")
                self.showError = true
                return
            }
            guard isValid(email: details.emailAddress) else {
                error = .invalidInput("Email address is invalid")
                self.showError = true
                return
            }
            if !details.twitterHandle.isEmpty {
                guard details.twitterHandle.hasPrefix("@") else {
                    error = .invalidInput("Twitter handle must start with a '@'")
                    self.showError = true
                    return
                }
            }
            self.error = nil
            generateImage()
        }
        
        private func generateImage() {
            Task {
                do {
                    guard let resultQRUIImage = QRCodeBadge.generate(data: details.asData(), scaledBy: 2) else {
                        throw AppError.failedToGenerateImage
                    }
                    withAnimation {
                        self.isBusy = true
                    }
                    let badgeUIImage = try await MainActor.run {
                        let renderer = ImageRenderer(
                            content: QRBadgeView(
                                details: details,
                                qrImage: Image(uiImage: resultQRUIImage)
                            )
                        )
                        renderer.scale = 2.7
                        guard let badgeUIImage = renderer.uiImage else {
                            throw AppError.failedToGenerateImage
                        }
                        return badgeUIImage
                    }
                    withAnimation {
                        self.isBusy = false
                        self.resultImage = Photo(
                            uiImage: badgeUIImage,
                            qrUIImage: resultQRUIImage
                        )
                    }
                } catch {
                    print(error)
                    if let appError = error as? AppError {
                        self.error = appError
                        self.showError = true
                        return
                    }
                    let nsError = error as NSError
                    self.error = .custom(nsError.description)
                    self.showError = true
                }
            }
        }
        
        private func isValid(email emailAddress: String) -> Bool {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailPred.evaluate(with: emailAddress)
        }
    }
}

fileprivate struct OutputView: View {
    let details: PersonalDetails
    let resultPhoto: Photo
    
    var body: some View {
        Form {
            QRBadgeView(details: details, qrImage: resultPhoto.qrImage)
            
            ShareLink(item: resultPhoto.image, preview: resultPhoto.sharePreview) {
                Label("Share Badge", systemImage: "square.and.arrow.up")
            }
        }
    }
}

fileprivate struct QRBadgeView: View {
    let details: PersonalDetails
    let qrImage: Image
    
    var body: some View {
        GroupBox {
            HStack {
                VStack(alignment: .leading) {
                    Text(details.emailAddress)
                        .font(.headline)
                    if !details.twitterHandle.isEmpty {
                        let label = Text(details.twitterHandle)
                            .font(.subheadline)
                        
                        if let url = URL(string: "https://x.com/\(details.twitterHandle)") {
                            Link(destination: url) {
                                label
                            }
                        } else {
                            label
                        }
                    }
                    if !details.githubHandle.isEmpty {
                        let label = Text(details.githubHandle)
                            .font(.subheadline)
                        
                        if let url = URL(string: "https://github.com/\(details.githubHandle)") {
                            Link(destination: url) {
                                label
                            }
                        } else {
                            label
                        }
                    }
                }
                
                Spacer()
                
                qrImage
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(width: 100)
            }
        } label: {
            Label("Contact \(details.name)", systemImage: "person.fill")
        }
    }
}

#Preview {
    FormView()
}
