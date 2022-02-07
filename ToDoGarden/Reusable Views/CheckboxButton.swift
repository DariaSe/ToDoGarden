//
//  CheckboxButton.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 05.02.2022.
//

import SwiftUI


struct CheckboxButton: View {
    
    @Binding var isOn: Bool
    
    var body: some View {
        Button {
            withAnimation(.easeOut(duration: 0.2)) {
                isOn.toggle()
            }
        } label: {
            Image(systemName: isOn ? "checkmark.square" : "square")
        }
        .buttonStyle(CheckboxButtonStyle())
    }
}


struct CheckboxButton_Previews: PreviewProvider {
    static var previews: some View {
        CheckboxButton(isOn: .constant(true))
            .previewLayout(.sizeThatFits)
    }
}

struct CheckboxButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            .font(.title2)
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .foregroundColor(.buttonColor)
            .opacity(configuration.isPressed ? 0.9 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
