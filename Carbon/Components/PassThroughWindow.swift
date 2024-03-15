//
//  PassThroughWindow.swift
//  Carbon
//
//  Created by Harsh on 15/03/24.
//

import SwiftUI
import UIKit

final class PassThroughWindow: UIWindow {
    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let view = super.hitTest(point, with: event) else {return nil}
        return rootViewController?.view == view ? nil : view
    }
}

