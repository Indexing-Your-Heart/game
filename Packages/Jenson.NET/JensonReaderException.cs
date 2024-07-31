#region Copyright
//
//  JensonReaderException.cs
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 14/7/2024.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.
#endregion

using Jenson.NET;

/// <summary>
/// An exception thrown by the <see cref="Jenson.NET.JensonReader"/> class when an error occurs during reading a
/// Jenson document.
/// </summary>
[Serializable]
public class JensonReaderException : Exception
{
    /// <summary>
    /// An enumeration representing the known cases of exceptions that the reader can throw.
    /// </summary>
    public enum KnownCase
    {
        /// <summary>
        /// The file is either empty or null.
        /// </summary>
        EmptyOrNull,
        
        /// <summary>
        /// The file is missing the <c>jenson</c> header.
        /// </summary>
        MissingHeader,
        
        /// <summary>
        /// The file is missing one or more of its required children: <c>story</c>, <c>timeline</c>.
        /// </summary>
        MissingRequiredChildren,
        
        /// <summary>
        /// The <c>story</c> block in the file is missing one or more of its required children: <c>name</c>,
        /// <c>authors</c>.
        /// </summary>
        MissingStoryChildren,
        
        /// <summary>
        /// The internal KDL parser encountered an error preventing the completion of parsing.
        /// </summary>
        /// <seealso cref="Kadlet.KdlException"/>
        KdlReaderError
    }

    /// <summary>
    /// Creates a Jenson reader exception, using a known exception case.
    /// </summary>
    /// <param name="knownCase">The known exception case to throw.</param>
    public JensonReaderException(KnownCase knownCase) : base(message: knownCase.Description()) { }

    public JensonReaderException() { }
    public JensonReaderException(string message) : base(message) { }
    public JensonReaderException(string message, Kadlet.KdlException innerException): base(message, innerException) { }
}
