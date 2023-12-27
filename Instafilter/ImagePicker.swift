//
//  ImagePicker.swift
//  Instafilter
//
//  Created by Maks Winters on 27.12.2023.
//

import Foundation
import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {

  @Binding var uiImage: UIImage?
  @Binding var isPresenting: Bool
   

  func makeUIViewController(context: Context) -> UIImagePickerController {

    let imagePicker = UIImagePickerController()

    imagePicker.sourceType = .photoLibrary

    imagePicker.delegate = context.coordinator

    return imagePicker

  }


  func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

  }

 
  typealias UIViewControllerType = UIImagePickerController
  

  func makeCoordinator() -> Coordinator {

    Coordinator(self)

  }
   

  class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

     

    let parent: ImagePicker

         

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

      parent.uiImage = info[.originalImage] as? UIImage

      parent.isPresenting = false

    }

     

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

      parent.isPresenting = false

    }

     

    init(_ imagePicker: ImagePicker) {

      self.parent = imagePicker

    }

     

  }


}
