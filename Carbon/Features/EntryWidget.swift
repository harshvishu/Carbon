//
//  EntryWidget.swift
//
//
//  Created by Harsh on 13/03/24.
//

import SwiftUI
import RiveRuntime

struct EntryWidgetView: View {
    @State private var riveViewModel = RiveViewModel(fileName: "leaf_animation", autoPlay: true)
    
    var body: some View {
        riveViewModel
            .view()
    }
}

#Preview {
    EntryWidgetView()
}
