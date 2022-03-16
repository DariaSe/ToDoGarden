//
//  RadioButton.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 07.02.2022.
//

import SwiftUI

struct RadioButton: View {
    
    var tag: Int
    @Binding var selectedTag: Int
    
    var body: some View {
        Button {
            withAnimation(.easeOut(duration: 0.2)) {
                selectedTag = tag
            }
        } label: {
            Image(systemName: selectedTag == tag ? "record.circle" : "circle")
        }
        .buttonStyle(CheckboxButtonStyle())
    }
}

struct RadioButton_Previews: PreviewProvider {
    static var previews: some View {
        RadioButton(tag: 1, selectedTag: .constant(0))
    }
}
