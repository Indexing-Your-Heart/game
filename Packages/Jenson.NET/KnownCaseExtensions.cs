#region Copyright

// KnownCaseExtensions.cs
// Indexing Your Heart
// 
// Created by Marquis Kurt on 31/07/2024.
// 
// This file is part of Indexing Your Heart.
// 
// Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
// CNPLv7+ as found in the LICENSE file in the source code root directory or at
// <https://git.pixie.town/thufie/npl-builder>.
// 
// Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
// details.

#endregion

namespace Jenson.NET;

public static class KnownCaseExtensions
{
    /// <summary>
    /// Retrieves the descriptive message of the known exception case.
    /// </summary>
    /// <remarks>
    /// This value is commonly used as the exception's message.
    /// </remarks>
    /// <param name="knownCase">The exception case to get the descriptive message of.</param>
    /// <returns>The descriptive message of the known exception case.</returns>
    public static string Description(this JensonReaderException.KnownCase knownCase) => knownCase switch
    {
        JensonReaderException.KnownCase.EmptyOrNull => "File is empty or null.",
        JensonReaderException.KnownCase.MissingHeader => "File has no Jenson header.",
        JensonReaderException.KnownCase.MissingRequiredChildren => "File is missing required children: timeline, story.",
        JensonReaderException.KnownCase.MissingStoryChildren => "The story block is missing its required children: name, authors.",
        JensonReaderException.KnownCase.KdlReaderError => "The KDL document parser encountered an error."
    };
}
