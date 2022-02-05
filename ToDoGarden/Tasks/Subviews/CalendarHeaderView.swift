//
//  DaySwitcherView.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 16.01.2022.
//

import SwiftUI

struct CalendarHeaderView: View {
    
    @Binding var date: Date
    @Binding var isCalendarShown: Bool
    
    var body: some View {
        HStack {
            Button {
                withAnimation(.easeOut(duration: 0.1)) {
                    date = isCalendarShown ? Calendar.current.date(byAdding: .month, value: -1, to: date)! : date.yesterday
                }
            } label: { Image(systemName: "arrow.backward.circle") }
            .buttonStyle(DaySwitcherButtonStyle())
            Button(isCalendarShown ? date.monthAndYear : date.formattedForHeader) {
                withAnimation(.easeOut(duration: 0.2)) {
                    isCalendarShown.toggle()
                }
            }
            .frame(maxWidth: .infinity)
            .font(.system(.headline, design: .rounded))
            .foregroundColor(.black)
            Button {
                withAnimation(.easeOut(duration: 0.1)) {
                    date = isCalendarShown ? Calendar.current.date(byAdding: .month, value: 1, to: date)! :  date.tomorrow
                }
            } label: { Image(systemName: "arrow.forward.circle") }
            .buttonStyle(DaySwitcherButtonStyle())
        }
    }
}

struct DaySwitcherView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarHeaderView(date: .constant(Date()), isCalendarShown: .constant(true))
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
