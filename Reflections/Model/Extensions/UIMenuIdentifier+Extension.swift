//
//  UIMenuIdentifier+Extension.swift
//  Reflections
//
//  Created by Gabriela Bezerra on 13/06/23.
//

import Foundation
import UIKit

extension UIMenu.Identifier: CaseIterable {
    public static var allCases: [UIMenu.Identifier] {
        [
            .about,
            .alignment,
            .application,
            .bringAllToFront,
            .close,
            .document,
            .edit,
            .file,
            .find,
            .font,
            .font,
            .format,
            .fullscreen,
            .help,
            .hide,
            .learn,
            .lookup,
            .minimizeAndZoom,
            .newScene,
            .openRecent,
            .preferences,
            .print,
            .quit,
            .replace,
            .root,
            .services,
            .share,
            .sidebar,
            .speech,
            .spelling,
            .spellingOptions,
            .spellingPanel,
            .standardEdit,
            .substitutionOptions,
            .substitutions,
            .substitutionsPanel,
            .substitutions,
            .text,
            .textColor,
            .textSize,
            .textStyle,
            .textStylePasteboard,
            .toolbar,
            .transformations,
            .undoRedo,
            .view,
            .window,
            .writingDirection
        ]
    }
}
