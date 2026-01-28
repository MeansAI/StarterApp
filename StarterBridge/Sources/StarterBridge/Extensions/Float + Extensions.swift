//
//  File.swift
//
//
//  Created by Justin Means on 2/1/22.
//

import Foundation

extension Float {
    func roundedString(_ to: Int) -> String {
        return String(format: "%.\(to)f", self)
    }

    func toHHMM() -> String {
        let minutes = Int(self / 60) % 60
        let hours = Int(self / 3600)
        return String(format: "%2d:%02d", hours, minutes)
    }

    func toHHMMSS() -> String {
        let seconds = Int(self) % 60
        let minutes = Int(self / 60) % 60
        let hours = Int(self / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
