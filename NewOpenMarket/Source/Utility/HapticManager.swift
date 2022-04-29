//
//  HapticManager.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/30.
//

import SwiftUI

final class HapticManager {
    
    @AppStorage("isHapticOn") private var isHapticOn: Bool = true
    
    static let shared = HapticManager()
    private static let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
    private static let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
    
    func haptic(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        guard isHapticOn else { return }
        Self.notificationFeedbackGenerator.notificationOccurred(type)
    }
    
    func selection() {
        guard isHapticOn else { return }
        Self.selectionFeedbackGenerator.selectionChanged()
    }
    
    private init() { }
}
