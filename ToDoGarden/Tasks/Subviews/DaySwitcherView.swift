//
//  DaySwitcherView.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 16.01.2022.
//

import SwiftUI

struct DaySwitcherView: View {
    
    var text: String
    
    var body: some View {
        HStack(spacing: 20) {
            Button {
                
            } label: {
                Image(systemName: "arrow.backward.circle")
                    
            }
            .buttonStyle(DaySwitcherButtonStyle())
            Button(text) {
                
            }
            .font(.system(.headline, design: .rounded))
            .foregroundColor(.black)
            Button {
                
            } label: {
                Image(systemName: "arrow.forward.circle")
            }
            .buttonStyle(DaySwitcherButtonStyle())
        }
        
    }
    
    var onPressForward: () -> ()
    
    var onPressBack: () -> ()
}

struct DaySwitcherView_Previews: PreviewProvider {
    static var previews: some View {
        DaySwitcherView(text: "May 1 2022", onPressForward: {}, onPressBack: {})
            .previewLayout(.sizeThatFits)
    }
}


struct DaySwitcherButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            .font(.title)
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .foregroundColor(configuration.isPressed ? .gray : .black)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
