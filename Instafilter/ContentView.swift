//
//  ContentView.swift
//  Instafilter
//
//  Created by Maks Winters on 27.12.2023.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct ContentView: View {
    
    @State private var currentFilter = CIFilter.pixellate()
    
    @State private var amount = 1.0
    
    @State private var image: Image?
    @State private var uiImage: UIImage?
    @State private var isPicking = false
    
    var body: some View {
        VStack {
            if image != nil {
                Spacer()
                image?
                    .resizable()
                    .scaledToFit()
                Spacer()
            } else {
                ContentUnavailableView("Pick an image", systemImage: "photo.badge.plus")
            }
            Slider(value: $amount, in: 0.1...1)
                .onChange(of: amount) { oldValue, newValue in
                    loadImage()
                }
                .padding()
            Button("Pick an image") {
                isPicking.toggle()
            }
            .sheet(isPresented: $isPicking, content: {
                ImagePicker(uiImage: $uiImage, isPresenting: $isPicking)
                    .onDisappear(perform: {
                        loadImage()
                    })
            })
        }
    }
    
    func loadImage() {
        guard let inputImage = uiImage else { return }
        let ciImage = CIImage(image: inputImage)
        
        let context = CIContext()
        
        currentFilter.inputImage = ciImage
        currentFilter.scale = Float(amount * 100)
        //        let amount = 1.0
        //        let inputKeys = currentFilter.inputKeys
        
        //        if inputKeys.contains(kCIInputIntensityKey) {
        //            currentFilter.setValue(amount, forKey: kCIInputIntensityKey)
        //        }
        //
        //        if inputKeys.contains(kCIInputRadiusKey) {
        //            currentFilter.setValue(amount * 360, forKey: kCIInputRadiusKey)
        //        }
        //
        //        if inputKeys.contains(kCIInputScaleKey) {
        //            currentFilter.setValue(amount * 10, forKey: kCIInputScaleKey)
        //        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        image = Image(uiImage: uiImage)
    }
    
}

#Preview {
    ContentView()
}
