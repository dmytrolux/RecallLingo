//
//  KeyboardHiden.swift
//  RecallLingo
//
//  Created by Pryshliak Dmytro on 13.04.2023.
//

import SwiftUI

extension UIApplication {
    func addTapGestureRecognizer() {
        guard let window = currentUIWindow() else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }
}

public extension UIApplication {
  func currentUIWindow() -> UIWindow? {
    let connectedScenes = UIApplication.shared.connectedScenes
    .filter { $0.activationState == .foregroundActive }
    .compactMap { $0 as? UIWindowScene }
    let window = connectedScenes.first?
    .windows
    .first { $0.isKeyWindow }
    return window
  }
}


extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true // set to `false` if you don't want to detect tap during other gestures
    }
}
