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
