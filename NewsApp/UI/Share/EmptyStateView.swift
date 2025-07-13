//
//  EmptyStateView.swift
//  NewsApp
//
//  Created by Yin Hua on 12/7/2025.
//

import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: AppConstants.Layout.largeSpacing) {
            Spacer()
            Image(systemName: icon)
                .font(.system(size: AppConstants.Layout.iconSize))
                .foregroundColor(.gray)
            Text(title)
                .font(Theme.Typography.headline)
            Text(subtitle)
                .font(Theme.Typography.subheadline)
                .foregroundColor(Theme.Colors.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppConstants.Layout.defaultPadding)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
