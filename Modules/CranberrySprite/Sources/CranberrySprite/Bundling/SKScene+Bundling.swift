//
//  SKScene+Bundling.swift
//
//
//  Created by Marquis Kurt on 4/16/23.
//

import SpriteKit

public extension SKScene {
    /// Returns an instance of a scene from a given bundle.
    ///
    /// This should be used to load SpriteKit files from other bundles such as in unit test resources or other Swift
    /// packages.
    ///
    /// - Parameter resource: The file name of the SpriteKit scene file to load from.
    /// - Parameter bundle: The bundle in where the scene file is stored.
    static func load(resourceNamed resource: String, bundle: Bundle) -> Self? {
        guard
            let path = bundle.path(forResource: resource, ofType: "sks"),
            let data = FileManager.default.contents(atPath: path)
        else {
            return nil
        }
        do {
            let unarchiver = try NSKeyedUnarchiver(forReadingFrom: data)
            unarchiver.requiresSecureCoding = false
            unarchiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = unarchiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey)
            unarchiver.finishDecoding()
            return scene as? Self
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
