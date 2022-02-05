//
//  CalendarView.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 16.01.2022.
//

import SwiftUI

struct CalendarView: View {
    
    @Binding var date: Date
    @Binding var isShown: Bool
    
    var body: some View {
        let calendarDays = CalendarFactory.makeCalendarDays(containing: date, selected: true)
        VStack {
            HStack {
                ForEach(Calendar.current.localWeekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.system(.caption2, design: .rounded))
                        .frame(maxWidth: .infinity)
                }
            }
            LazyVGrid(columns: [GridItem](repeating: GridItem(.flexible()), count: 7)) {
                ForEach(calendarDays) { calendarDay in
                    if calendarDay.belongsToMonth {
                        ZStack {
                            let today = calendarDay.date ==^ Date()
                            if today {
                                Circle()
                                    .strokeBorder(Color.AppColors.green, lineWidth: 3)
                            }
                            if calendarDay.isSelected {
                                Circle()
                                    .fill(Color.AppColors.green)
                            }
                            let dateString = Calendar.current.component(.day, from: calendarDay.date).string
                            Text(dateString)
                                .foregroundColor(calendarDay.isSelected ? .white : .black)
                                .font(.system(.body, design: .rounded))
                        }
                        .frame(minWidth: 40, idealWidth: 50, maxWidth: 60, minHeight: 40, idealHeight: 50, maxHeight: 60)
                        .onTapGesture {
                            date = calendarDay.date
                            withAnimation(.easeOut(duration: 0.2).delay(0.2)) {
                                isShown.toggle()
                            }
                        }
                    }
                    else {
                        Text("")
                    }
                }
            }
        }
        .padding()
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(date: .constant(Date()), isShown: .constant(true))
            .previewLayout(.sizeThatFits)
    }
}


struct CalendarFactory {
    
    static func makeCalendarDays(containing date: Date, selected: Bool) -> [CalendarDay] {
        let dates = Calendar.current.extendedMonth(containing: date)
        let calendarDays = dates.map { (arrayDate) -> CalendarDay in
            let belongsToMonth = arrayDate.belongsToMonth(of: date)
            let isSelected = (arrayDate.dayStart == date.dayStart) && selected
            return CalendarDay(date: arrayDate, belongsToMonth: belongsToMonth, isSelected: isSelected)
        }
        return calendarDays
    }
    
    static func numberOfWeeksInMonth(containing date: Date) -> Int {
        let dates = Calendar.current.extendedMonth(containing: date)
        return Int(ceil(Double(dates.count) / 7.0))
    }
}
