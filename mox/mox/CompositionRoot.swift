//
//  CompositionRoot.swift
//  mox
//
//  Created by 이경민 on 6/14/26.
//

import SwiftUI


struct MacContentView: View {
    var body: some View {
        RootView()
            .frame(minWidth: 860, minHeight: 580)
    }
}

struct CompositionRoot: View {
    var body: some View {
        MacContentView()
    }
}
