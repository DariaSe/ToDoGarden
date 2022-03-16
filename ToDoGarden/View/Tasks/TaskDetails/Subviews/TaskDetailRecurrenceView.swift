//
//  TaskDetailRecurrenceView.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 07.02.2022.
//

import SwiftUI

struct TaskDetailRecurrenceView: View {
    
    @Binding var isRepeating: Bool
    
    @Binding var recurrenceType: RecurrenceRule.RecurrenceType
    @Binding var recurrenceFrequency: RecurrenceFrequency
    @Binding var interval: Int
    @Binding var selectedWeekdays: [Int]
    
    var body: some View {
        let recurrenceTypeInt = Binding<Int>(
            get: { recurrenceType.rawValue },
            set: { recurrenceType = RecurrenceRule.RecurrenceType(rawValue: $0) ?? RecurrenceRule.RecurrenceType.regular }
        )
        let recurrenceFrequencyInt = Binding<Int>(
            get: { recurrenceFrequency.rawValue },
            set: { recurrenceFrequency = RecurrenceFrequency(rawValue: $0) ?? .daily }
        )
        VStack {
            HStack {
                CheckboxButton(isOn: $isRepeating)
                Text(Strings.repeatt)
                    .font(.system(.body, design: .rounded))
                    .opacity(isRepeating ? 1 : 0.8)
                Spacer()
            }
            if isRepeating {
                VStack {
                    HStack {
                        RadioButton(tag: 0, selectedTag: recurrenceTypeInt)
                        let menuOptions =  RecurrenceFrequency.allCases.map {$0.string}
                        DropdownMenu(menuOptions: menuOptions, optionSelected: recurrenceFrequencyInt) {
                            recurrenceType = .regular
                        }
                        Spacer()
                    }
                    HStack {
                        RadioButton(tag: 1, selectedTag: recurrenceTypeInt)
                        Text(Strings.every)
                        let intervalText = Binding<String>(
                            get: { interval == 0 ? "" : interval.string },
                            set: { interval = Int($0) ?? 0 }
                        )
                        TextField("", text: intervalText)
                            .font(.system(.body, design: .rounded))
                            .padding()
                            .frame(width: 60, height: 50)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.textControlsBGColor))
                            .keyboardType(.decimalPad)
                        let menuOptions = RecurrenceFrequency.allCases.map{$0.string(interval)}
                        DropdownMenu(menuOptions: menuOptions, optionSelected: recurrenceFrequencyInt) {
                            recurrenceType = .withIntervals
                        }
                        Spacer()
                    }
                    VStack {
                        HStack {
                            RadioButton(tag: 2, selectedTag: recurrenceTypeInt)
                            Text(Strings.onWeekdays)
                            Spacer()
                        }
                        HStack(spacing: 0) {
                            ForEach(0..<7) { index in
                                let isSelected = selectedWeekdays.contains(index + 1)
                                Button {
                                    recurrenceType = .onWeekdays
                                    if isSelected {
                                        selectedWeekdays = selectedWeekdays.filter {$0 != (index + 1) }
                                    }
                                    else {
                                        selectedWeekdays.append(index + 1)
                                    }
                                } label: {
                                    Text(Calendar.current.localWeekdaySymbols[index])
                                        .font(.system(.subheadline, design: .rounded))
                                        .frame(width: 42, height: 42)
                                        .background(RoundedRectangle(cornerRadius: 8)
                                                        .fill(isSelected ? Color.buttonColor : Color.textControlsBGColor)
                                                        .padding(.all, 2))
                                }
                                .foregroundColor(isSelected ? .white : .buttonColor)
                            }
                        }
                    }
                    
                }
                .padding(.leading, 40)
            }
        }
    }
}

struct TaskDetailRecurrenceView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailRecurrenceView(isRepeating: .constant(true), recurrenceType: .constant(RecurrenceRule.RecurrenceType.regular), recurrenceFrequency: .constant(.daily), interval: .constant(0), selectedWeekdays: .constant([]))
    }
}
