//
//  LoadingView.swift
//  NewsApp
//
//  Created by Yin Hua on 12/7/2025.
//

import SwiftUI

struct LoadingView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: AppConstants.Layout.defaultSpacing) {
            ProgressView()
            Text(message)
                .font(Theme.Typography.subheadline)
                .foregroundColor(Theme.Colors.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height * 0.6)
        .listRowInsets(EdgeInsets())
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
}
