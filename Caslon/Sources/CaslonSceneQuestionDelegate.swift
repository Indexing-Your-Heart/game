//
//  CaslonSceneQuestionDelegate.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 10/5/22.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.

import Foundation
import JensonKit

/// A protocol that indicates an object is capable of handling question events from Jenson files.
public protocol CaslonSceneQuestionDelegate: AnyObject {
    /// The list of options the player can choose from.
    var options: [JensonChoice] { get set }

    /// A method called when the options are first loaded into the delegate.
    ///
    /// To load a question, call ``load(question:)``.
    func willLoadOptions(from question: JensonQuestion)

    /// A method called when the options are loaded into the delegate.
    ///
    /// To load a question, call ``load(question:)``.
    func didLoadOptions()

    /// Returns the name of the option that was selected on-screen.
    /// - Parameter location: The coordinates of where the player has clicked.
    /// - Returns: The name of the option that was selected, or `nil` if the player didn't select an option.
    func selectedOption(at location: CGPoint) -> String?

    /// A method fired when the user selects an option.
    ///
    /// To select an option with a name, call ``selectOption(named:)``.
    /// - Parameter name: The name of the choice that the player selected. The name matches the name in the Jenson file.
    func didSelectOption(with name: String)

    /// Returns whether the scene should ignore clicks on other places.
    ///
    /// This is typically used to prevent the player from accidentally advancing in a Jenson timeline while in a menu.
    func shouldBlockOtherInputs() -> Bool
}

public extension CaslonSceneQuestionDelegate {
    /// Loads a question into the delegate.
    /// - Parameter question: The question that will be loaded into the delegate.
    func load(question: JensonQuestion) {
        willLoadOptions(from: question)
        options = question.options
        didLoadOptions()
    }

    /// Selects the option with a corresponding name. The name should match `choice:<choice_name_here>`.
    /// If no option is found with that name, nothing occurs.
    /// - Parameter optionName: The option name that should be selected.
    func selectOption(named optionName: String) {
        let strippedName = String(optionName.trimmingPrefix("choice:"))
        let choices = options.map(\.name)
        guard choices.contains(strippedName) else { return }
        didSelectOption(with: strippedName)
    }
}
