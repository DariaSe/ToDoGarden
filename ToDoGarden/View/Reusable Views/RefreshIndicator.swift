//
//  RefreshIndicator.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 03.03.2022.
//

import SwiftUI

struct RefreshIndicator: View {
    
    static let coordinateSpaceName = "pullToRefresh"
    
    @Binding private var needsRefresh: Bool
    private let onRefresh: () -> Void
    
    init(needsRefresh: Binding<Bool>, onRefresh: @escaping () -> Void) {
        self._needsRefresh = needsRefresh
        self.onRefresh = onRefresh
    }
    
    var body: some View {
        HStack(alignment: .center) {
            if needsRefresh {
                ProgressView()
                    .padding()
            }
        }
        .background(GeometryReader {
            Color.clear.preference(key: ScrollViewOffsetPreferenceKey.self,
                                   value: $0.frame(in: .named(RefreshIndicator.coordinateSpaceName)).origin.y)
        })
        .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { offset in
            guard !needsRefresh else { return }
            if offset > 50 {
                needsRefresh = true
                onRefresh()
            }
        }
    }
}


struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }

}
