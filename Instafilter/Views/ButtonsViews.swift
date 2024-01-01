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

struct CDButtons: View {
    
    @State var CVModel: ContentViewModel
    @Environment(\.requestReview) var requestReview
    @AppStorage("shareCounter") var filterSetCounter = 0
    
    var body: some View {
        Button("Bloom") { setFilter(CIFilter.bloom()) }
        Button("Crystallize") { setFilter(CIFilter.crystallize()) }
        Button("xRay") { setFilter(CIFilter.xRay()) }
        Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
        Button("Pixellate") { setFilter(CIFilter.pixellate()) }
        Button("Area Average") { setFilter(CIFilter.areaAverage()) }
        Button("Thermal") { setFilter(CIFilter.thermal()) }
        Button("Vignette") { setFilter(CIFilter.vignette()) }
        Button("Comic Effect") { setFilter(CIFilter.comicEffect()) }
    }
    
    @MainActor func setFilter(_ filter: CIFilter) {
        if filterSetCounter == 5 {
            requestReview()
        }
        filterSetCounter += 1
            
        CVModel.currentFilter = filter
        CVModel.loadImage()
    }
}
