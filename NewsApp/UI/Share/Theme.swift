//
//  Theme.swift
//  NewsApp
//
//  Created by Yin Hua on 12/7/2025.
//

import Foundation
import SwiftUI

struct Theme {
    struct Colors {
        static let primary = Color.primary
        static let secondary = Color.secondary
        static let accent = Color.blue
        static let destructive = Color.red
        static let placeholder = Color.gray.opacity(0.3)
    }
    
    struct Typography {
        static let largeTitle = Font.largeTitle
        static let title = Font.title
        static let headline = Font.headline
        static let subheadline = Font.subheadline
        static let body = Font.body
        static let caption = Font.caption
        static let caption2 = Font.caption2
    }
}

