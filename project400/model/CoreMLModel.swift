//
//  CoreMLModel.swift
//  project400
//
//  Created by Omar Alshuaili on 10/02/2023.
//

import Foundation
import UIKit
import CoreML


class CoreMLModel {
    var CamerModel : CameraScannModel = CameraScannModel()
    func classifyImage(uiImage : UIImage)  -> Int {
        var result = 0
        do{
            let multiArray = try? CamerModel.convertToMultiArray(uiImage)
            let config = MLModelConfiguration()
            let model = try BreastCancerDetection(configuration:config)
            let prediction = try model.prediction(conv2d_input: multiArray!)
            result =  Int(prediction.Identity[0].doubleValue * 100.0)
        }
        catch{
            
        }
        
        return result
    }
}
