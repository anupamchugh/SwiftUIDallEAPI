//
//  ContentView.swift
//  SwiftUIDallEAPI
//
//  Created by Anupam Chugh on 21/11/22.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var fetcher = OpenAIService()
    @State var photos : [Photo] = []
    @State private var textPrompt: String = ""

    var body: some View {
        VStack {

            List {
               ForEach(photos, id: \.url) { photo in

                   AsyncImage(url: URL(string: photo.url)) { image in
                               image
                                   .resizable()
                                   .aspectRatio(contentMode: .fit)
                           } placeholder: {
                               Image(systemName: "photo.fill")
                           }.frame(maxWidth: .infinity, maxHeight: 500)
                       .listRowInsets(.init(.zero))
               }
            }

            TextField("Enter the prompt", text: $textPrompt)
                        .textFieldStyle(RoundedTextFieldStyle())
                        .padding()
            
            Button(action: runOpenAIGeneration, label: {Text("Generate Text From Prompt")})
        }
        .padding()
    }
    
    func runOpenAIGeneration(){
        Task{
            do{
                self.photos = try await fetcher.generateImage(from: textPrompt)
            }catch(let error){
                print(error)
            }
        }
    }
}

struct RoundedTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.vertical)
            .padding(.horizontal, 24)
            .background(
                Color(UIColor.systemGray6)
            )
            .clipShape(Capsule(style: .continuous))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
