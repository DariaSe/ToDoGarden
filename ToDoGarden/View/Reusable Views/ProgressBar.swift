//
//  ProgressBar.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 16.03.2022.
//

import SwiftUI

struct ProgressBar: View {
    
    let progress: CGFloat
    let barColor: Color = Color.AppColors.mint
    let trackColor: Color = Color.white
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 2).fill(trackColor)
                HStack {
                    RoundedRectangle(cornerRadius: 2).fill(barColor)
                        .frame(width: geometry.size.width * progress)
                    Spacer()
                }
            }
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(progress: 0.5)
            .frame(width: 100, height: 6)
    }
}
