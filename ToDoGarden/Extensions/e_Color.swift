//
//  e_Color.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 20.01.2022.
//

import SwiftUI

extension Color {
    
    init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0)
    }
    init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
}


extension Color {
    
    static var backgroundColor: Color = Color(netHex: 0xF5F4ED)
    static var taskCellBGColor: Color = Color(netHex: 0xFCFBF5)
    
//    static var borderColor: Color = Color.lightGray
    
    static var textColor: Color = Color.AppColors.darkGreen
    
    static var buttonColor: Color = Color.AppColors.darkGreen
    
    static var textControlsBGColor = Color(netHex: 0xF2F2F7)
    
    static var destructiveColor = Color(netHex: 0xbe4c48)
    
    static var startGradientColor = Color(netHex: 0xF7F6F0)
    static var middleGradientColor = Color(netHex: 0xEBEAE0)
    static var endGradientColor = Color(netHex: 0xDEDDCF)
    
    struct AppColors {
        //0
        static let noColorColor = Color(netHex: 0xc7c7c7)
        //1
        static let orange = Color(netHex: 0xf5932a)
        //2
        static let brickRed = Color(netHex: 0xb44d07)
        //3
        static let red = Color(netHex: 0xbe4c48)
        //4
        static let yellow = Color(netHex: 0xd8c55b)
        //5
        static let darkGreen = Color(netHex: 0x164031)
        //6
        static let green = Color(netHex: 0x216367)
        //7
        static let mint = Color(netHex: 0x67bb9f)
        //8
        static let blue = Color(netHex: 0x23639a)
        //9
        static let purple = Color(netHex: 0x4c3e86)
        //10
        static let lilac = Color(netHex: 0x813d6f)
        //11
        static let brown = Color(netHex: 0x4b2828)
     
    }
    
    static var taskColors: [Color] { return [Color.AppColors.noColorColor, Color.AppColors.orange, Color.AppColors.brickRed, Color.AppColors.red, Color.AppColors.yellow, Color.AppColors.darkGreen, Color.AppColors.green, Color.AppColors.mint, Color.AppColors.blue, Color.AppColors.purple, Color.AppColors.lilac, Color.AppColors.brown] }

}


extension Color {
    static func randomTagColor() -> Color {
        let randomInt = Int.random(in: 0...11)
        return taskColors[randomInt]
    }
}

extension Color {
    static func tagColor(index: Int) -> Color {
        return taskColors[index]
    }
}
