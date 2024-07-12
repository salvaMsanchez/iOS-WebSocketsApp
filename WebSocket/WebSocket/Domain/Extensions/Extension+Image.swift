//
//  Extension+Image.swift
//  WebSocket
//
//  Created by Salva Moreno on 19/3/24.
//

import SwiftUI

extension Image {
    enum Symbol: String {
        // SF Symbol
        case person3Fill = "person.3.fill"
        case magnifyingglass
        case personCircleFill = "person.circle.fill"
        case envelopeCircleFill = "envelope.circle.fill"
        case lockCircleFill = "lock.circle.fill"
        case xmarkCircleFill = "xmark.circle.fill"
    }
}

extension Image {
    init(_ symbol: Image.Symbol) {
        self.init(systemName: symbol.rawValue)
    }
}
