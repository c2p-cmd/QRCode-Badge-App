//
//  DetailsModel.swift
//  QRCodeBadgeGenerator
//
//  Created by Sharan Thakur on 16/10/24.
//

import Foundation

struct PersonalDetails: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var emailAddress: String
    var twitterHandle: String
    var githubHandle: String
}

extension PersonalDetails {
    static var empty: PersonalDetails {
        PersonalDetails(name: "", emailAddress: "", twitterHandle: "", githubHandle: "")
    }
}

/// Codable Extensions
extension PersonalDetails: Codable {
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case emailAddress = "email_address"
        case twitterHandle = "twitter"
        case githubHandle = "github"
    }
    
    /// Initializer from ``Data``
    /// - Parameter data: `JSON` encoded ``Data``
    init(fromData data: Data) throws {
        let details = try JSONDecoder().decode(PersonalDetails.self, from: data)
        self.emailAddress = details.emailAddress
        self.twitterHandle = details.twitterHandle
        self.githubHandle = details.githubHandle
        self.name = details.name
    }
    
    /// Method to encode as `JSON` data
    /// - Returns: ``Data`` with `JSON` encoded properties
    func asData() throws -> Data {
        try JSONEncoder().encode(self)
    }
}
