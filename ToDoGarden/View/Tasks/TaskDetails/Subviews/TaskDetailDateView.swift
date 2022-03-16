//
//  TaskDetailDateView.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 07.02.2022.
//

import SwiftUI

struct TaskDetailDateView: View {
    
    @State private var isCalendarShown: Bool = false
    @Binding var startDate: Date
    var isRecurring: Bool
    
    var body: some View {
        VStack {
            HStack(spacing: 40) {
                Text(isRecurring ?  Strings.startDate : Strings.date)
                    .font(.system(.body, design: .rounded))
                    .padding(.leading, 50)
                Button {
                    isCalendarShown.toggle()
                } label: {
                    Text(startDate.formattedForHeader)
                }
                .foregroundColor(Color.buttonColor)
                .font(.system(.headline, design: .rounded))
                Spacer()
            }
            if isCalendarShown {
                CalendarHeaderView(date: $startDate, isCalendarShown: .constant(true))
                CalendarView(date: $startDate, isShown: $isCalendarShown)
            }
        }
    }
}

struct TaskDetailDateView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailDateView(startDate: .constant(Date()), isRecurring: true)
    }
}
