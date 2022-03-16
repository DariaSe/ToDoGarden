//
//  PullToRefresh.swift
//  ToDoGarden
//
//  Created by Дарья Селезнёва on 03.03.2022.
//

import SwiftUI

import SwiftUI

struct PullToRefreshSwiftUI: View {
    @Binding private var needsRefresh: Bool
    private let coordinateSpaceName: String
    private let onRefresh: () -> Void
    
    init(needsRefresh: Binding<Bool>, coordinateSpaceName: String, onRefresh: @escaping () -> Void) {
        self._needsRefresh = needsRefresh
        self.coordinateSpaceName = coordinateSpaceName
        self.onRefresh = onRefresh
    }
    
    var body: some View {
        HStack(alignment: .center) {
            if needsRefresh {
                VStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .frame(height: 100)
            }
        }
        .background(GeometryReader {
            Color.clear.preference(key: ScrollViewOffsetPreferenceKey.self,
                                   value: $0.frame(in: .named(coordinateSpaceName)).origin.y)
        })
        .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { offset in
            guard !needsRefresh else { return }
            if abs(offset) > 50 {
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
