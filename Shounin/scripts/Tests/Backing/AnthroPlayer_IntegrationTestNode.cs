#region Copyright
//
// AnthroPlayer_IntegrationTestNode.cs
// Indexing Your Heart
//
// Created by Marquis Kurt on 28/07/2024.
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
using IndexingYourHeart.Entities;

namespace IndexingYourHeart.Tests.Backing;

public partial class AnthroPlayer_IntegrationTestNode : Node2D
{
    private AnthroPlayer player;

    public override void _Ready()
    {
        base._Ready();
        player = GetNode<AnthroPlayer>("Player");
    }

    public float GetPlayerPositionX() => player.Position.X;
    public float GetPlayerPositionY() => player.Position.Y;
}
