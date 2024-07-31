//
//  Extensions.swift
//  MenuLight
//
//  Created by Dan Diemer on 7/30/24.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let red = (rgbValue & 0xFF0000) >> 16
        let green = (rgbValue & 0x00FF00) >> 8
        let blue = rgbValue & 0x0000FF
        self.init(
            .sRGB,
            red: Double(red) / 255,
            green: Double(green) / 255,
            blue: Double(blue) / 255,
            opacity: 1
        )
    }

    func toHex() -> String {
        let components = self.cgColor?.components ?? [0, 0, 0]
        let red = Int(components[0] * 255)
        let green = Int(components[1] * 255)
        let blue = Int(components[2] * 255)
        return String(format: "%02X%02X%02X", red, green, blue)
    }
}

extension Data {
    init(hex: String) {
        self.init(hex.chunked(into: 2).compactMap {
            UInt8($0, radix: 16)
        })
    }
  var hexDescription: String {
          return reduce("") {$0 + String(format: "%02x", $1)}
      }
}

//
//extension Array where Element == UInt8 {
//    init(hex: String) {
//        self = hex.unicodeScalars.chunked(into: 2).compactMap {
//            UInt8(String($0), radix: 16)
//        }
//    }
//}
//
//extension Sequence {
//    func chunked(into size: Int) -> [[Element]] {
//        var chunks: [[Element]] = []
//        var iterator = makeIterator()
//        while let first = iterator.next() {
//            var chunk = [first]
//            for _ in 1..<size {
//                if let next = iterator.next() {
//                    chunk.append(next)
//                } else {
//                    break
//                }
//            }
//            chunks.append(chunk)
//        }
//        return chunks
//    }
//}
extension String {
    func chunked(into size: Int) -> [String] {
        var chunks: [String] = []
        var startIndex = self.startIndex
        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: size, limitedBy: self.endIndex) ?? self.endIndex
            chunks.append(String(self[startIndex..<endIndex]))
            startIndex = endIndex
        }
        return chunks
    }
}
