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
    
    @State var CVModel = ContentViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.background)
                    .ignoresSafeArea()
                    .navigationTitle("Instafilter")
                VStack {
                    Spacer()
                    PhotosPicker(selection: $CVModel.pickerItem, matching: .images) {
                        if CVModel.image != nil {
                            CVModel.image!
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
                    .onChange(of: CVModel.pickerItem) { oldValue, newValue in
                        CVModel.loadImage()
                    }
                    Spacer()
                    HStack {
                        Text(CVModel.currentKeyString)
                            .bold()
                        ValueSlider(value: $CVModel.filterAmount)
                            .valueSliderStyle(
                                HorizontalValueSliderStyle(
                                    track:
                                        HorizontalTrack(view: Color.blue)
                                        .frame(height: 3)
                                        .background(Color.red)
                                        .cornerRadius(1.5)
                                )
                            )
                            .opacity(CVModel.image == nil ? 0.5 : 1)
                            .disabled(CVModel.image == nil)
                            .onChange(of: CVModel.filterAmount) { oldValue, newValue in
                                CVModel.applyFilter()
                            }
                    }
                    .frame(height: 50)
                    .padding(.horizontal)
                    HStack {
                        Button { CVModel.changeFilter() } label: { CFButton() }
                            .opacity(CVModel.image == nil ? 0.5 : 1)
                            .disabled(CVModel.image == nil)
                        if CVModel.image != nil {
                            ShareLink(item: CVModel.image!, preview: SharePreview("Final image", image: CVModel.image!)) {
                                ShareButton()
                            }
                        }
                    }
                    .padding(.bottom, 5)
                }
            }
            .confirmationDialog("Choose filter", isPresented: $CVModel.filterMenu) {
                CDButtons(CVModel: CVModel)
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
