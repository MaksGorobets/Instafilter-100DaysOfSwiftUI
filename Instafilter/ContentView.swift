//
//  ContentView.swift
//  Instafilter
//
//  Created by Maks Winters on 27.12.2023.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI
import SwiftUI
import StoreKit
import Sliders

struct ContentView: View {
    @Environment(\.requestReview) var requestReview
    @State private var image: Image?
    @State private var filterAmount = 0.5
    @State private var pickerItem: PhotosPickerItem?
    @State private var filterMenu = false
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    
    @AppStorage("shareCounter") var filterSetCounter = 0
    
    let context = CIContext()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.background)
                    .ignoresSafeArea()
                    .navigationTitle("Instafilter")
                VStack {
                    Spacer()
                    PhotosPicker(selection: $pickerItem, matching: .images) {
                        if let image {
                            image
                                .resizable()
                                .scaledToFit()
                                .padding(5)
                                .background(LinearGradient(colors: [.blue, .red], startPoint: .leading, endPoint: .trailing))
                                .shadow(color: .red, radius: 5)
                        } else {
                            ContentUnavailableView("No image", systemImage: "arrow.up", description: Text("Tap to pick a photo"))
                        }
                    }
                    .buttonStyle(.plain)
                    .onChange(of: pickerItem) { oldValue, newValue in
                        loadImage()
                    }
                    Spacer()
                    HStack {
                        Text("Intensity")
                            .bold()
                        ValueSlider(value: $filterAmount)
                            .valueSliderStyle(
                                HorizontalValueSliderStyle(
                                    track:
                                        HorizontalTrack(view: Color.blue)
                                        .frame(height: 3)
                                        .background(Color.red)
                                        .cornerRadius(1.5)
                                )
                            )
                            .onChange(of: filterAmount) { oldValue, newValue in
                                applyFilter()
                            }
                    }
                    .frame(height: 50)
                    .padding(.horizontal)
                    HStack {
                        Button { changeFilter() } label: { CFButton() }
                        if image != nil {
                            ShareLink(item: image!, preview: SharePreview("Final image", image: image!)) {
                                ShareButton()
                            }
                        }
                    }
                    .padding(.bottom, 5)
                }
            }
            .confirmationDialog("Choose filter", isPresented: $filterMenu) {
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
        }
        .preferredColorScheme(.dark)
    }
    
    func changeFilter() {
        filterMenu.toggle()
    }
    
    func loadImage() {
        Task {
            guard let rawImage = try await pickerItem?.loadTransferable(type: Data.self) else { return }
            let ciImage = CIImage(data: rawImage)
            currentFilter.setValue(ciImage, forKey: kCIInputImageKey)
            applyFilter()
        }
        
    }
    
    func applyFilter() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterAmount, forKey: kCIInputIntensityKey) }
        
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterAmount * 50, forKey: kCIInputScaleKey) }
        
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterAmount * 200 , forKey: kCIInputRadiusKey) }
        
        guard let outputImage = currentFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        let uiImage = UIImage(cgImage: cgImage)
        image = Image(uiImage: uiImage)
    }
    
    @MainActor func setFilter(_ filter: CIFilter) {
        if filterSetCounter == 5 {
            requestReview()
        }
        filterSetCounter += 1
            
        currentFilter = filter
        loadImage()
    }
}

#Preview {
    ContentView()
}
