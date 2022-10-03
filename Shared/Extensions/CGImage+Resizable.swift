//
//  CGImage+Resizable.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 10/3/22.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.

import CoreGraphics
import UIKit
import UniformTypeIdentifiers

extension CGImage {
    /// Returns a new `CGImage` that is resized to the specified size.
    /// - Parameter size: The new size of the `CGImage`.
    func resized(to size: CGSize) -> CGImage? {
        guard let colorSpace = colorSpace else { return nil }
        guard let ctx = CGContext(
            data: nil,
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: alphaInfo.rawValue
        ) else { return nil }
        ctx.interpolationQuality = .high
        ctx.draw(self, in: CGRect(origin: .zero, size: size))
        return ctx.makeImage()
    }

    /// Writes the `CGImage` to the specified file name.
    /// - Important: This method is only available on iOS.
    /// - Parameter filename: The name of the file to write to.
    @available(iOS 16.0, *)
    func write(to filename: String) {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let firstPath = paths[0]
        let url = firstPath.appending(path: filename).appendingPathExtension("png")
        _ = url.startAccessingSecurityScopedResource()
        if let dest = CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil) {
            CGImageDestinationAddImage(dest, self, nil)
            CGImageDestinationFinalize(dest)
        }
        url.stopAccessingSecurityScopedResource()
    }
}
