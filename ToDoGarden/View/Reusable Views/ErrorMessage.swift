//
//  ErrorMessage.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 12.02.2022.
//

import SwiftUI

struct ErrorMessage: View {
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.destructiveColor)
                .frame(width: 300, height: 60)
            Text(Strings.errorMessage)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
    }
}

struct ErrorMessage_Previews: PreviewProvider {
    static var previews: some View {
        ErrorMessage()
    }
}
