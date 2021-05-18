//
//  Created on 2021-05-17
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var teamManager: TeamManager
    private let colorsGenerator = ColorGenerator()

    var body: some View {
        VStack() {
            Group {
                if let dev = teamManager.selectedDeveloper {
                    Text(dev.nickname ?? dev.firstName)
                } else {
                    Text("🤷‍♂️")
                }
            }
            .font(.largeTitle)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

            Spacer()

            HStack {
                Button("Skip", action: {
                    teamManager.skip()
                })
                .keyboardShortcut(.init("s"), modifiers: [])
                .disabled(teamManager.selectedDeveloper == nil)

                Button("Next", action: {
                    teamManager.next()
                })
                .keyboardShortcut(.init("n"), modifiers: [])
                .keyboardShortcut(.rightArrow, modifiers: [])
                .disabled(teamManager.team.isEmpty)
            }

            ScrollView(.horizontal) {
                HStack {
                    ForEach(teamManager.team) { dev in
                        Text(dev.initials)
                            .padding()
                            .font(.title)
                            .fixedSize()
                            .background(colorsGenerator.color(for: dev.id))
                            .cornerRadius(6)
                            .aspectRatio(1, contentMode: .fit)
                    }
                }.padding()
            }
            .fixedSize(horizontal: false, vertical: true)
            .frame(minHeight: 100)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .frame(width: 450, height: 300, alignment: .center)
            .previewDevice("Mac")
            .environmentObject(TeamManager(developers: [
                .init(firstName: "Vasily", lastName: "Pupkin", nickname: nil, labels: []),
                .init(firstName: "George", lastName: "Washington", nickname: "Washington", labels: []),
                .init(firstName: "John", lastName: "Doe", nickname: "Johny", labels: []),
            ]))
    }
}
