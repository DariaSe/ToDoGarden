//
//  TaskListDateView.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 07.02.2022.
//

import SwiftUI

struct TaskListDateView: View {
    
    @Binding var date: Date
    @State var isCalendarShown: Bool = false
    
    var body: some View {
        VStack {
            CalendarHeaderView(date: $date, isCalendarShown: $isCalendarShown)
                .frame(maxWidth: UIScreen.main.bounds.width - 90)
            if isCalendarShown {
                CalendarView(date: $date, isShown: $isCalendarShown)
            }
        }
    }
}

struct TaskListDateView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListDateView(date: .constant(Date()))
    }
}
