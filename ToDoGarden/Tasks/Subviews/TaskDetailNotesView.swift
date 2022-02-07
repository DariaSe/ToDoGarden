//
//  TaskDetailNotesView.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 07.02.2022.
//

import SwiftUI

struct TaskDetailNotesView: View {
    
    @Binding var notes: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(Strings.notes + ":")
                .padding(.horizontal)
            TextEditor(text: $notes)
                .padding(.horizontal)
                .background(RoundedRectangle(cornerRadius: 25).fill(Color.textControlsBGColor))
                .frame(height: 100)
        }
        .font(.system(.body, design: .rounded))
    }
}

struct TaskDetailNotesView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailNotesView(notes: .constant("Some notes"))
    }
}
