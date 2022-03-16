//
//  TaskDetailColorView.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 07.02.2022.
//

import SwiftUI

struct TaskDetailColorView: View {
    
    @Binding var isColorSelected: Bool
    @State private var isColorPickerShown: Bool = false
    @Binding var color: Int?
    
    var body: some View {
        VStack {
            HStack {
                CheckboxButton(isOn: $isColorSelected)
                Text(Strings.color)
                    .font(.system(.body, design: .rounded))
                    .opacity(isColorSelected ? 1 : 0.8)
                if isColorSelected {
                    RoundedRectangle(cornerRadius: 16)
                        .inset(by: 8)
                        .fill(Color.taskColors[color ?? 0])
                        .frame(width: 50)
                        .transition(.opacity)
                        .onTapGesture {
                            withAnimation(.easeOut(duration: 0.2)) {
                                isColorPickerShown.toggle()
                            }
                        }
                }
                Spacer()
            }
            .frame(height: 50)
            if isColorSelected && isColorPickerShown {
                LazyVGrid(columns: [GridItem](repeating: GridItem(.flexible()), count: 6), spacing: 0) {
                    ForEach(0..<12) { int in
                        RoundedRectangle(cornerRadius: 16)
                            .inset(by: 8)
                            .fill(Color.taskColors[int])
                            .frame(width: 50, height: 50)
                            .onTapGesture {
                                color = int
                                withAnimation(.easeOut(duration: 0.2)) {
                                    isColorPickerShown = false
                                }
                            }
                    }
                }
                .transition(.opacity)
                .frame(width: 300, height: 100)
            }
        }
    }
}

struct TaskDetailColorView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailColorView(isColorSelected: .constant(true), color: .constant(4))
    }
}
