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
import Sliders



struct ContentView: View {
    @State private var image: Image?
    @State private var filterAmount = 0.5
    @State private var pickerItem: PhotosPickerItem?
    
    @State private var currentFilter = CIFilter.sepiaTone()
    
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
                        Button {
                            changeFilter()
                        } label: {
                            CFButton()
                        }
                        Button {
                            //sharing
                        } label: {
                            Circle()
                                .foregroundStyle(.blue)
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Image(systemName: "square.and.arrow.up")
                                        .foregroundStyle(.white)
                                )
                        }
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    func changeFilter() {
        
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
        currentFilter.intensity = Float(filterAmount)
        guard let outputImage = currentFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        let uiImage = UIImage(cgImage: cgImage)
        image = Image(uiImage: uiImage)
    }
    
}

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

#Preview {
    ContentView()
}
