//
//  Created on 2021-05-17
//

import Foundation

final class TeamManager: ObservableObject {
    @Published private var developers: [Developer]
    @Published var selectedDeveloper: Developer?

    var team: ReversedCollection<[Developer]> {
        developers.reversed()
    }

    init(developers: [Developer]) {
        self.developers = developers.shuffled()
        next()
    }

    func next() {
        selectedDeveloper = developers.popLast()
    }

    func skip() {
        guard let selectedDeveloper = selectedDeveloper else {
            return
        }

        developers.insert(selectedDeveloper, at: 0)
        next()
    }
}

struct Developer: Decodable, Identifiable {
    let firstName: String
    let lastName: String
    let nickname: String?
    let labels: [String]

    var id: String {
        firstName + lastName
    }

    var initials: String {
        "\(firstName.prefix(1))\(lastName.prefix(1))"
    }
}
