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

    func importItem(_ item: DropInfo) {
        guard let provider = item.itemProviders(for: [.fileURL]).first else {
            return
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
    }

    var content: some View {
        let dropDelegate = DropTeamDelegate(isDropping: $isDropping, importItem: self.importItem(_:))

        return ContentView()
            .onDrop(of: [.fileURL], delegate: dropDelegate)
            .frame(width: 750, height: 400, alignment: .center)
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

struct DropTeamDelegate: DropDelegate {
    @Binding var isDropping: Bool
    let importItem: (DropInfo) -> Void

    func dropEntered(info: DropInfo) {
        isDropping = true
    }

    func dropExited(info: DropInfo) {
        isDropping = false
    }

    func performDrop(info: DropInfo) -> Bool {
        defer {
            importItem(info)
        }

        isDropping = false
        return true
    }
}
