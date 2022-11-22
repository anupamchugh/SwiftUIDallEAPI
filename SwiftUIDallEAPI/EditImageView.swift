//
//  EditImageView.swift
//  SwiftUIDallEAPI
//
//  Created by Anupam Chugh on 22/11/22.
//

import SwiftUI

struct EditImageView: View {
    
    @StateObject var visionProcessing  = VisionRequester()
    @StateObject var fetcher = OpenAIService()
    @State var inputImage : UIImage = UIImage(named: "person")!
    @State var photos : [Photo] = []
        
    var body: some View {
        
        
        HStack{
            if let outputImage = self.visionProcessing.maskedImage{
                Image(uiImage: outputImage)
                    .resizable()
                    .aspectRatio(contentMode:.fit)
                    .onReceive(self.visionProcessing.$maskedImage,
                               perform: { updated in
                        if let _ = updated?.size{
                            Task{
                                do{
                                    self.photos = try await fetcher.generateEditedImage(from: inputImage, with: outputImage)
                                }catch(let error){
                                    print(error)
                                }
                            }
                        }
                    })
            }
            
            List {
               ForEach(photos, id: \.url) { photo in
                   AsyncImage(url: URL(string: photo.url)) { image in
                        image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                   } placeholder: {
                       Image(systemName: "photo.fill")
                   }.frame(maxWidth: .infinity, maxHeight: .infinity)
                    .listRowInsets(.init(.zero))
               }
            }
            
            
            Button("Generate Face"){
                visionProcessing.maskFaceUsingVisionRequest(inputImage: inputImage)
            }
            .padding()
            
            
        }
    }
}

struct EditImageView_Previews: PreviewProvider {
    static var previews: some View {
        EditImageView()
    }
}
