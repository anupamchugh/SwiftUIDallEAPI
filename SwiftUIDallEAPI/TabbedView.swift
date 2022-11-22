//
//  TabbedView.swift
//  SwiftUIDallEAPI
//
//  Created by Anupam Chugh on 22/11/22.
//

import SwiftUI

struct TabbedView: View {
    var body: some View {
        
        TabView {
          ContentView()
            .tabItem {
              Text("Text Prompts")
            }
            .tag(0)
          EditImageView()
            .tabItem {
              Text("Edit Image")
            }
            .tag(1)
        }
        
    }
}

struct TabbedView_Previews: PreviewProvider {
    static var previews: some View {
        TabbedView()
    }
}
