//
//  VisionRequester.swift
//  SwiftUIDallEAPI
//
//  Created by Anupam Chugh on 22/11/22.
//

import Foundation
import UIKit
import Vision

class VisionRequester: ObservableObject{
    
    @Published var maskedImage: UIImage?
    //1 - @Published
    var faceRect: VNFaceObservation?
    
    func maskFaceUsingVisionRequest(inputImage: UIImage){
        
        let request = VNDetectFaceRectanglesRequest()
        let handler = VNImageRequestHandler(cgImage: inputImage.cgImage!, options: [:])
        Task{
            do{
                try handler.perform([request])
                
                guard let results = request.results else {return}
                faceRect = results.first //2
                guard let faceRect else {return}
                
                let box = getBoundingBoxes(rect: faceRect, on: inputImage.size)
                                
                await MainActor.run{
                    self.maskedImage = erase(region: box, from: inputImage)
                }
                
            }catch{
                print(error)
            }
        }
    }
    
    func getBoundingBoxes(rect : VNFaceObservation, on imageSize: CGSize) -> CGRect {
            
        let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -imageSize.height)
        let scale = CGAffineTransform.identity.scaledBy(x: imageSize.width, y: imageSize.height)

        let bounds = rect.boundingBox.applying(scale).applying(transform)
        
        return bounds
            
    }
    
    func erase(region: CGRect, from image: UIImage) -> UIImage? {
            UIGraphicsBeginImageContext(image.size)
            image.draw(at: CGPoint.zero)
            let context = UIGraphicsGetCurrentContext()!
            let bez = UIBezierPath(rect: region)
            context.addPath(bez.cgPath)
            context.clip()
            context.clear(CGRect(x:0,y:0,width: image.size.width,height: image.size.height))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return newImage
    }
}
