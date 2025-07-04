#region Copyright
// UIAnimationExtensions.cs
// Indexing Your Heart
// 
// Created by Marquis Kurt on 04/07/2025.
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
using System;
using System.Collections.Generic;

namespace IndexingYourHeart.Utils;

// ReSharper disable once InconsistentNaming
public readonly struct UIAnimationProperty(GodotObject target, NodePath property, Variant endState)
{
    public required GodotObject Target { get; init; } = target;

    public required NodePath Property { get; init; } = property;

    public required Variant EndState { get; init; } = endState;
}

// ReSharper disable once InconsistentNaming
public static class UIAnimationExtensions
{
    /// <summary>
    /// Perform an animation and execute an action upon completion.
    /// </summary>
    /// <param name="node">The node that the tween will be created from.</param>
    /// <param name="animation">The animation that will be executed.</param>
    /// <param name="property">The property to animate.</param>
    /// <param name="completion">The completion handler that executes when the animation has finished.</param>
    public static void WithAnimation(
        this Node node,
        UIAnimation animation,
        UIAnimationProperty property,
        Action? completion = null)
    {
        var animator = node.CreateTween().SetEase(animation.Easing).SetTrans(animation.Transition).Parallel();
        if (completion != null)
            animator.Finished += completion;
        animator.TweenProperty(property.Target, property.Property, property.EndState, animation.Duration);
    }

    /// <summary>
    /// Perform an animation and execute an action upon completion.
    /// </summary>
    /// <param name="node">The node that the tween will be created from.</param>
    /// <param name="animation">The animation that will be executed.</param>
    /// <param name="properties">The properties to animate.</param>
    /// <param name="concurrent">Whether the properties should be animated concurrently.</param>
    /// <param name="completion">The completion handler that executes when the animation has finished.</param>
    public static void WithAnimation(this Node node,
        UIAnimation animation,
        List<UIAnimationProperty> properties,
        bool concurrent = true,
        Action? completion = null)
    {
        var animator = node.CreateTween().SetEase(animation.Easing).SetTrans(animation.Transition).SetParallel(concurrent);
        if (completion != null)
            animator.Finished += completion;
        foreach (var property in properties)
        {
            animator.TweenProperty(property.Target, property.Property, property.EndState, animation.Duration);
        }
    }
}
