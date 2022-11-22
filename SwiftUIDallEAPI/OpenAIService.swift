//
//  APIService.swift
//  SwiftUIDallEAPI
//
//  Created by Anupam Chugh on 21/11/22.
//

import Foundation
import UIKit

enum OpenAIEndpoint: String{
    
    private var baseURL: String { return "https://api.openai.com/v1/images/" }
    
    case generations
    case edits
    
    var url: URL {
            guard let url = URL(string: baseURL) else {
                preconditionFailure("The url is not valid")
            }
            return url.appendingPathComponent(self.rawValue)
    }
}

class OpenAIService: ObservableObject{
    
    let api_key_free = "<INSERT_API_KEY>"
    
    func generateImage(from prompt: String) async throws -> [Photo]{
        var request = URLRequest(url: OpenAIEndpoint.generations.url)
        request.setValue("Bearer \(api_key_free)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let parameters: [String: Any] = [
            "prompt": prompt,
            "n": 1,
            "size": "256x256"
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        
        request.httpBody = jsonData

        let (data, _) = try await URLSession.shared.data(for: request)
        let dalleResponse = try? JSONDecoder().decode(DALLEResponse.self, from: data)
        
        return dalleResponse?.data ?? []

    }
    
    func generateEditedImage(from image: UIImage, with mask: UIImage) async throws -> [Photo]  {
        
        guard let imageData = image.pngData() else{return []}
        guard let maskData = mask.pngData() else{return []}
        
        let formFields: [String: String] = [
            "prompt": "A woman wearing a red dress with a laughter face expression",
            "size": "256x256"
        ]
        
        let multipart = MultipartFormDataRequest(url: OpenAIEndpoint.edits.url)
        multipart.addDataField(fieldName:  "image", fileName: "image.png", data: imageData, mimeType: "image/png")
        multipart.addDataField(fieldName:  "mask", fileName: "mask.png", data: maskData, mimeType: "image/png")
        
        for (key, value) in formFields {
            multipart.addTextField(named: key, value: value)
        }

        var request = multipart.asURLRequest()
        request.setValue("Bearer \(api_key_free)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let dalleResponse = try? JSONDecoder().decode(DALLEResponse.self, from: data)
        
        return dalleResponse?.data ?? []
            
    }
}
