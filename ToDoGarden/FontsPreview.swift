//
//  FontsPreview.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 20.01.2022.
//

import SwiftUI

struct FontsPreview: View {
    var body: some View {
        VStack {
            Text("Hello, World! - largeTitle")
                .font(.largeTitle)
            
            Text("Hello, World! - title")
                .font(.title)
            
            Text("Hello, World! - title2")
                .font(.title2)
            
            Text("Hello, World! - title3")
                .font(.title3)
            
            Text("Hello, World! - headline")
                .font(.headline)
            
            Text("Hello, World! - subheadline")
                .font(.subheadline)
            
            Text("Hello, World! - body")
                .font(.body)
            
            Text("Hello, World! - callout")
                .font(.callout)
            
            Text("Hello, World! - caption")
                .font(.caption)
            
            Text("Hello, World! - caption2")
                .font(.caption2)
            
//            Text("Hello, World! - footnote")
//                .font(.footnote)
        }
    }
}

struct FontsPreview_Previews: PreviewProvider {
    static var previews: some View {
        FontsPreview()
    }
}
