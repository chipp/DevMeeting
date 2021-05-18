//
//  Created on 2021-05-17
//

import SwiftUI
import CryptoKit

final class ColorGenerator {
    private var cache: [String: Color] = [:]

    func color(for id: String) -> Color {
        if let color = cache[id] {
            return color
        } else {
            let color = generateColor(for: id)
            cache[id] = color
            return color
        }
    }

    private func generateColor(for id: String) -> Color {
        let md5 = Array(Insecure.MD5.hash(data: id.data(using: .utf8)!).prefix(3))
        return Color(red: Double(md5[0]) / 255, green: Double(md5[1]) / 255, blue: Double(md5[2]) / 255, opacity: 1)
    }
}
