//
//  TaskDetailNotificationView.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 07.02.2022.
//

import SwiftUI

struct TaskDetailNotificationView: View {
    
    @Binding var isNotificationOn: Bool
    @Binding var notificationDate: Date
    
    var body: some View {
        HStack {
            CheckboxButton(isOn: $isNotificationOn)
            Text(Strings.notification)
                .font(.system(.body, design: .rounded))
                .opacity(isNotificationOn ? 1 : 0.8)
            if isNotificationOn {
                DatePicker(selection: $notificationDate, displayedComponents: .hourAndMinute) {}
                .padding(.trailing, 60)
            }
            Spacer()
        }
    }
}

struct TaskDetailNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailNotificationView(isNotificationOn: .constant(true), notificationDate: .constant(Date()))
    }
}
