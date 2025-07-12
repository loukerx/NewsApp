//
//  SourceRowView.swift
//  NewsApp
//
//  Created by Yin Hua on 12/7/2025.
//

import SwiftUI

struct SourceRowView: View {
    let source: NewsSource
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: AppConstants.Layout.smallSpacing) {
                Text(source.name)
                    .font(Theme.Typography.headline)
                Text(source.description)
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.secondary)
            }
            
            Spacer()
            
            if isSelected {
                Image(systemName: AppConstants.Images.checkmarkCircleFill)
                    .foregroundColor(Theme.Colors.accent)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
}
