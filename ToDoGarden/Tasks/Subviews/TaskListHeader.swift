//
//  TaskListHeader.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 12.02.2022.
//

import SwiftUI

struct TaskListHeader: View {
    
    @Binding var date : Date
    @State var isCalendarShown : Bool = false
    
    var onTapAdd : () -> Void
    
    var body: some View {
        VStack {
            ZStack {
                CalendarHeaderView(date: $date, isCalendarShown: $isCalendarShown)
                    .frame(maxWidth: UIScreen.main.bounds.width - 90)
                HStack {
                    Spacer()
                    Button {
                        onTapAdd()
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.black)
                            .font(.system(.headline, design: .rounded))
                    }
                    .frame(width: 60, height: 60)
                }
            }
            if isCalendarShown {
                CalendarView(date: $date, isShown: $isCalendarShown)
            }
        }
    }
}

struct TaskListHeader_Previews: PreviewProvider {
    static var previews: some View {
        TaskListHeader(date: .constant(Date()), onTapAdd: {})
    }
}
