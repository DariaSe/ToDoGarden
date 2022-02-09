//
//  TaskDetailRecurrenceView.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 07.02.2022.
//

import SwiftUI

struct TaskDetailRecurrenceView: View {
    
    @Binding var isRepeating: Bool
    
    @ObservedObject var recurrenceRule: RecurrenceRule
    
    var body: some View {
        var recurrenceType = Binding<Int>(
            get: { recurrenceRule.recurrenceType.rawValue },
            set: { recurrenceRule.recurrenceType = RecurrenceRule.RecurrenceType(rawValue: $0) ?? RecurrenceRule.RecurrenceType.regular }
        )
        let recurrenceFrequency = Binding<Int>(
            get: { recurrenceRule.recurrenceFrequency?.rawValue ?? 0},
            set: { recurrenceRule.recurrenceFrequency = RecurrenceFrequency(rawValue: $0) }
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
                        RadioButton(tag: 0, selectedTag: recurrenceType)
                        let menuOptions =  RecurrenceFrequency.allCases.map {$0.string}
                        DropdownMenu(menuOptions: menuOptions, optionSelected: recurrenceFrequency) {
                            recurrenceRule.recurrenceType = .regular
                        }
                        Spacer()
                    }
                    HStack {
                        RadioButton(tag: 1, selectedTag: recurrenceType)
                        Text(Strings.every)
                        let intervalText = Binding<String>(
                            get: { recurrenceRule.interval == 0 ? "" : recurrenceRule.interval.string },
                            set: { recurrenceRule.interval = Int($0) ?? 0 }
                        )
                        TextField("", text: intervalText)
                            .font(.system(.body, design: .rounded))
                            .padding()
                            .frame(width: 60, height: 50)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.textControlsBGColor))
                            .keyboardType(.decimalPad)
                        let menuOptions = RecurrenceFrequency.allCases.map{$0.string(recurrenceRule.interval)}
                        DropdownMenu(menuOptions: menuOptions, optionSelected: recurrenceFrequency) {
                            recurrenceRule.recurrenceType = .withIntervals
                        }
                        Spacer()
                    }
                    VStack {
                        HStack {
                            RadioButton(tag: 2, selectedTag: recurrenceType)
                            Text(Strings.onWeekdays)
                            Spacer()
                        }
                        HStack(spacing: 0) {
                            ForEach(0..<7) { index in
                                let isSelected = recurrenceRule.weekdays.contains(index)
                                Button {
                                    recurrenceRule.recurrenceType = .onWeekdays
                                    if isSelected {
                                        recurrenceRule.weekdays = recurrenceRule.weekdays.filter {$0 != index }
                                    }
                                    else {
                                        recurrenceRule.weekdays.append(index)
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
        .onAppear {
            
        }
    }
}

struct TaskDetailRecurrenceView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailRecurrenceView(isRepeating: .constant(true), recurrenceRule: RecurrenceRule(recurrenceType: .regular, recurrenceFrequency: .daily, interval: 0, weekdays: []))
    }
}
