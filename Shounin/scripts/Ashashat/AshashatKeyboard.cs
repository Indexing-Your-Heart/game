#region Copyright
// AshashatKeyboard.cs
// Indexing Your Heart
// 
// Created by Marquis Kurt on 04/08/2024.
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

using Godot;

namespace IndexingYourHeart.Ashashat;

// TODO: Write unit tests for this!

public partial class AshashatKeyboard : VBoxContainer
{
	public override void _Ready()
	{
		Node mainGrid = GetNode("Main Grid");
		AttachKeyListenerToChildren(mainGrid);

		Node specialsRow = GetNode("Specials Row");
		AttachKeyListenerToChildren(specialsRow);

		KeyPressed += (KeyCode) =>
		{
			GD.Print($"Key {KeyCode} was pressed!");
		};

	}

	private void AttachKeyListenerToChildren(Node parent)
	{
		foreach (Node node in parent.GetChildren())
		{
			if (node.Name.ToString().StartsWith("Empty") || node.Name == "Spacer")
				continue;

			VirtualAshashatKey key = (VirtualAshashatKey)node;
			key.KeyPressed += (KeyCode) => EmitSignal(SignalName.KeyPressed, KeyCode);
		}
	}

	[Signal]
	public delegate void KeyPressedEventHandler(string KeyCode);
}
