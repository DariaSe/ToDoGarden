//
//  TaskDetailNotificationView.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 07.02.2022.
//

import SwiftUI

struct TaskDetailNotificationView: View {
    
    @State var isNotificationsDisallowedAlertShown: Bool = false
    
    @Binding var isNotificationOn: Bool
    @Binding var notificationDate: Date
    
    var body: some View {
        HStack {
            CheckboxButton(isOn: $isNotificationOn) {
                if isNotificationOn {
                    NotificationService.shared.requestAuthorization { granted in
                        if granted {
                            Defaults.notificationsAllowanceAsked = true
                        }
                        else {
                            isNotificationsDisallowedAlertShown = true
                        }
                    }
                }
            }
            Text(Strings.reminder)
                .font(.system(.body, design: .rounded))
                .opacity(isNotificationOn ? 1 : 0.8)
            if isNotificationOn {
                DatePicker(selection: $notificationDate, displayedComponents: .hourAndMinute) {}
                .padding(.trailing, 60)
            }
            Spacer()
        }
        .alert(isPresented: $isNotificationsDisallowedAlertShown, content: {
            Alert(title: Text(Strings.toSettings), primaryButton: .default(Text(Strings.settings), action: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }), secondaryButton: .cancel())
        })
    }
}

struct TaskDetailNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailNotificationView(isNotificationOn: .constant(true), notificationDate: .constant(Date()))
    }
}
