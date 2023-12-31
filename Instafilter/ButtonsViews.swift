//
//  ButtonsViews.swift
//  Instafilter
//
//  Created by Maks Winters on 31.12.2023.
//

import Foundation
import SwiftUI

struct CFButton: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .foregroundStyle(LinearGradient(colors: [.blue, .red], startPoint: .leading, endPoint: .trailing))
            HStack {
                Text("Change filter")
                Image(systemName: "pencil")
            }
            .foregroundStyle(.white)
        }
        .frame(width: 200, height: 50)
    }
}

struct ShareButton: View {
    var body: some View {
        Circle()
            .foregroundStyle(.blue)
            .frame(width: 50, height: 50)
            .overlay(
                Image(systemName: "square.and.arrow.up")
                    .foregroundStyle(.white)
            )
    }
}
