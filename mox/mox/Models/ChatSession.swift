//
//  ChatSession.swift
//  mox
//
//  Created by 이경민 on 6/14/26.
//

import Foundation

struct ChatSession: Identifiable, Hashable {
    let id: UUID
    var title: String
    
    init(id: UUID = UUID(), title: String) {
        self.id = id
        self.title = title
    }
}
