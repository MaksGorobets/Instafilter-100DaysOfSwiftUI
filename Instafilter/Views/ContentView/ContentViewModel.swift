//
//  ContentViewModel.swift
//  Instafilter
//
//  Created by Maks Winters on 01.01.2024.
//

import Foundation
import SwiftUI
import PhotosUI

@Observable
final class ContentViewModel {
    
    var currentKeyString = "Intensity"
    var image: Image?
    var filterAmount = 0.5
    var pickerItem: PhotosPickerItem?
    var filterMenu = false
    
    var currentFilter: CIFilter = CIFilter.sepiaTone()
    
    let context = CIContext()
    
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
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentKeyString = "Intensity"
            currentFilter.setValue(filterAmount, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputScaleKey) {
            currentKeyString = "Scale"
            currentFilter.setValue(filterAmount * 50, forKey: kCIInputScaleKey)
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            currentKeyString = "Radius"
            currentFilter.setValue(filterAmount * 200 , forKey: kCIInputRadiusKey)
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        let uiImage = UIImage(cgImage: cgImage)
        image = Image(uiImage: uiImage)
    }
}
