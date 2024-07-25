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

[Serializable]
public class JensonReaderException : Exception
{
    public const string EmptyMessage = "File is empty or null.";
    public const string MissingHeader = "File has no Jenson header.";
    public const string MissingRequiredChildren = "File is missing required children: timeline, story.";
    public const string MissingStoryChildren = "The story block is missing its required children: name, authors.";
    public const string KdlReaderError = "The KDL document parser encountered an error.";

    public JensonReaderException() { }
    public JensonReaderException(string message) : base(message) { }
    public JensonReaderException(string message, Kadlet.KdlException innerException): base(message, innerException) { }
}
