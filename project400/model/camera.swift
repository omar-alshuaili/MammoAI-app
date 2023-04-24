//
//  camera.swift
//  project400
//
//  Created by Omar Alshuaili on 27/01/2023.
//
import Foundation
import UIKit
import CoreML
class CameraScannModel {
    
    func convertToMultiArray(_ image: UIImage) -> MLMultiArray? {
        

        guard let cgImage = image.cgImage else {
            return nil
        }
        
        let width = cgImage.width
        let height = cgImage.height
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        context.draw(cgImage, in: rect)
        
        guard let pixelBuffer = context.data else {
            return nil
        }
        
        // Change the shape of multiArray to [1, 50, 50, 3]
        let multiArray = try? MLMultiArray(shape: [1, 50, 50, 3], dataType: MLMultiArrayDataType.float32)
        
        let dataPointer = multiArray?.dataPointer.bindMemory(to: Float.self, capacity: width * height * 3)
        let pixelBufferPointer = pixelBuffer.bindMemory(to: UInt8.self, capacity: width * height * 4)
        
        // Resize the image to 50 x 50
        let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 50, height: 50))
        let resizedCgImage = resizedImage.cgImage
        
        for y in 0..<50 {
            for x in 0..<50 {
                for c in 0..<3 {
                    let offset = y * 50 * 4 + x * 4 + c
                    dataPointer?[y * 50 * 3 + x * 3 + c] = Float(pixelBufferPointer[offset]) / 255.0
                }
            }
        }
        return multiArray
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    
    
    func pixelBuffer(forImage image: UIImage) -> CVPixelBuffer? {
        let width = Int(image.size.width)
        let height = Int(image.size.height)
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard status == kCVReturnSuccess else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
}
