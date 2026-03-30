//
//  AppStoreLookupService.swift
//  Iterly
//
//  Created by Filippo Cilialet on 30/03/2026.
//

import Foundation

enum AppStoreSyncError: LocalizedError {
    case invalidAppID
    case appNotFound
    case invalidResponse

    var errorDescription: String? {
        switch self {
        case .invalidAppID:
            "Enter a valid App Store app ID."
        case .appNotFound:
            "No App Store app matched that ID."
        case .invalidResponse:
            "The App Store response was invalid."
        }
    }
}

struct AppStoreLookupResult: Sendable {
    let appID: String
    let version: String
    let storeURL: String
}

struct AppStoreLookupService {
    func lookup(appID: String) async throws -> AppStoreLookupResult {
        let trimmedAppID = try extractedAppID(from: appID)

        var components = URLComponents(string: "https://itunes.apple.com/lookup")
        components?.queryItems = [
            URLQueryItem(name: "id", value: trimmedAppID)
        ]

        guard let url = components?.url else {
            throw AppStoreSyncError.invalidResponse
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw AppStoreSyncError.invalidResponse
        }

        let decodedResponse = try JSONDecoder().decode(AppStoreLookupResponse.self, from: data)
        guard let app = decodedResponse.results.first else {
            throw AppStoreSyncError.appNotFound
        }

        return AppStoreLookupResult(
            appID: trimmedAppID,
            version: app.version,
            storeURL: app.trackViewURL
        )
    }

    func extractedAppID(from rawValue: String) throws -> String {
        let trimmedValue = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmedValue.isEmpty == false else {
            throw AppStoreSyncError.invalidAppID
        }

        if trimmedValue.allSatisfy(\.isNumber) {
            return trimmedValue
        }

        if let appID = firstMatch(in: trimmedValue, pattern: #"(?i)id(\d+)"#) {
            return appID
        }

        if let digitRun = firstMatch(in: trimmedValue, pattern: #"(\d{5,})"#) {
            return digitRun
        }

        throw AppStoreSyncError.invalidAppID
    }

    private func firstMatch(in text: String, pattern: String) -> String? {
        guard let expression = try? NSRegularExpression(pattern: pattern) else { return nil }
        let fullRange = NSRange(text.startIndex..<text.endIndex, in: text)
        guard let match = expression.firstMatch(in: text, range: fullRange) else { return nil }

        let captureRange = match.numberOfRanges > 1 ? match.range(at: 1) : match.range(at: 0)
        guard let swiftRange = Range(captureRange, in: text) else { return nil }

        let candidate = String(text[swiftRange])
        return candidate.isEmpty ? nil : candidate
    }
}

private struct AppStoreLookupResponse: Decodable {
    let results: [AppStoreLookupApp]
}

private struct AppStoreLookupApp: Decodable {
    let version: String
    let trackViewURL: String

    enum CodingKeys: String, CodingKey {
        case version
        case trackViewURL = "trackViewUrl"
    }
}
