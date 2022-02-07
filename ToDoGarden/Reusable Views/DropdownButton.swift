//
//  DropdownButton.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 07.02.2022.
//

import SwiftUI

struct DropdownButton: View {
    
    @Binding var text: String
    @State private var showsOptions: Bool = false
    
    var body: some View {
        if showsOptions {
            
        }
        Button {
            
        } label: {
            HStack {
                Text(text)
                Image(systemName: "arrowtriangle.down.fill")
            }
            .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
            .background(RoundedRectangle(cornerRadius: 12).strokeBorder(lineWidth: 1.5, antialiased: true))
        }
        
        .foregroundColor(.buttonColor)
    }
}

struct DropdownButton_Previews: PreviewProvider {
    static var previews: some View {
        DropdownButton(text: .constant("Daily"))
    }
}
