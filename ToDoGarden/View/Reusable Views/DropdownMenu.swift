//
//  DropdownMenu.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 08.02.2022.
//

import SwiftUI

struct DropdownMenu: View {
    
    var menuOptions: [String]
    @Binding var optionSelected: Int
    
    var onSelection: () -> ()
    
    var body: some View {
        Menu {
            ForEach(0..<menuOptions.count) { index in
                Button {
                    optionSelected = index
                    onSelection()
                } label: {
                    Label(menuOptions[index], systemImage: optionSelected == index ? "checkmark" : "")
                }
            }
        } label: {
            DropdownButton(text: menuOptions[optionSelected])
        }
    }
}

struct DropdownMenu_Previews: PreviewProvider {
    static var previews: some View {
        DropdownMenu(menuOptions: [Strings.daily, Strings.weekly, Strings.monthly, Strings.yearly], optionSelected: .constant(1), onSelection: {})
    }
}
