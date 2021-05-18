//
//  Created on 2021-05-17
//

import SwiftUI

@main
struct DevMeetingApp: App {
    private let teamManager: TeamManager

    init() {
        let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("dev_meeting")
            .appendingPathExtension("plist")

        let data = try! Data(contentsOf: url)
        let developers = try! PropertyListDecoder().decode([Developer].self, from: data)

        teamManager = .init(developers: developers)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(width: 750, height: 400, alignment: .center)
                .environmentObject(teamManager)
        }
    }
}
