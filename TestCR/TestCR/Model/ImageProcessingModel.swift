//
//  ImageProcessor.swift
//  TestCR
//
//  Created by Ильнур Салахов on 21.11.2024.
//

import UIKit

class ImageProcessingModel {
    var images: [UIImage] = []

    func loadImages() {
        for i in 1...10 {
            if let image = UIImage(named: "Image\(i)") {
                images.append(image)
            }
        }
    }

    // Применение фильтров
    func applyFilter(to image: UIImage) -> UIImage? {
        let filterNames = ["CIPhotoEffectNoir", "CIPhotoEffectChrome", "CIPhotoEffectFade"]
        guard let randomFilterName = filterNames.randomElement(),
              let filter = CIFilter(name: randomFilterName),
              let ciImage = CIImage(image: image) else { return nil }
        
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        guard let outputImage = filter.outputImage else { return nil }

        let context = CIContext()
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }

    func factorial(of n: Int) async -> Int {
        var result = 1
                for i in 1...n {
                    result *= i
                    try? await Task.sleep(nanoseconds: 100_000_000)
                }
                return result
    }
}


