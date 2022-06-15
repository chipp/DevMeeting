//
//  Created on 2021-05-17
//

import SwiftUI
import UniformTypeIdentifiers

@main
struct DevMeetingApp: App {
    private var teamManager: TeamManager

    @State var isDropping = false

    init() {
        teamManager = .init(developers: FileDataProvider.loadDevelopers())
    }

    func importItems(_ providers: [NSItemProvider]) -> Bool {
        guard let provider = providers.first else {
            return false
        }

        provider.loadDataRepresentation(forTypeIdentifier: UTType.fileURL.identifier) { data, error in
            if let url = data.flatMap({ String(data: $0, encoding: .utf8) }).flatMap(URL.init(string:)) {
                let developers = FileDataProvider.loadDevelopers(from: url)
                FileDataProvider.saveDevelopers(developers)

                DispatchQueue.main.async {
                    teamManager.updateDevelopers(developers)
                }
            } else if let error = error {
                // TODO:
                fatalError("\(error)")
            }
        }

        return true
    }

    var content: some View {
        ContentView()
            .frame(width: 750, height: 400, alignment: .center)
            .onDrop(of: [.fileURL], isTargeted: $isDropping, perform: self.importItems(_:))
            .environmentObject(teamManager)
    }

    var body: some Scene {
        WindowGroup {
            if isDropping {
                content.border(Color.red, width: 2)
            } else {
                content
            }
        }
    }
}
