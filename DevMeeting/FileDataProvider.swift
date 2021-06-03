//
//  Created on 2021-05-27
//

import Foundation

enum FileDataProvider {
    private static let defaultURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        .appendingPathComponent("dev_meeting")
        .appendingPathExtension("plist")

    static func loadDevelopers() -> [Developer] {
        loadDevelopers(from: defaultURL)
    }

    static func saveDevelopers(_ developers: [Developer]) {
        do {
            let data = try PropertyListEncoder().encode(developers)
            try data.write(to: defaultURL)
        } catch {
            assertionFailure("\(error)")
        }
    }

    static func loadDevelopers(from url: URL) -> [Developer] {
        do {
            let data = try Data(contentsOf: url)
            return try PropertyListDecoder().decode([Developer].self, from: data)
        } catch {
            assertionFailure("\(error)")
            return []
        }
    }
}
