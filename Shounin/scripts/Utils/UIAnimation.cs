using Godot;
using System;
using System.Collections.Generic;

namespace IndexingYourHeart.Utils;

// ReSharper disable once InconsistentNaming
/// <summary>
/// A class used to define an animation that occurs in a tween.
/// </summary>
/// <remarks>
/// Use this with the <code>WithAnimation</code> extension methods in <see cref="UIAnimationExtensions"/> to set up
/// animations.
/// </remarks>
/// <param name="duration">The duration of the animation.</param>
/// <param name="easing">The easing to use for the animation.</param>
/// <param name="animation">The animation that will play.</param>
public class UIAnimation(double duration, Tween.EaseType easing, Tween.TransitionType animation)
{
    /// <summary>
    /// The easing to use for the animation.
    /// </summary>
    public Tween.EaseType Easing { get; private set; } = easing;

    /// <summary>
    /// The animation that will play.
    /// </summary>
    public Tween.TransitionType Transition { get; private set; } = animation;

    /// <summary>
    /// The duration of the animation.
    /// </summary>
    public double Duration { get; private set; } = duration;

    /// <summary>
    /// Creates a default animation with the specified property groups.
    /// </summary>
    /// <returns></returns>
    public static UIAnimation Default()
    {
        return new UIAnimation(1, Tween.EaseType.InOut, Tween.TransitionType.Linear);
    }

    /// <summary>
    /// Creates a linear animation with the specified duration and property groups.
    /// </summary>
    /// <param name="duration">The duration of the animation.</param>
    /// <returns></returns>
    public static UIAnimation LinearEaseInOut(double duration = 0.5)
    {
        return new UIAnimation(duration, Tween.EaseType.InOut, Tween.TransitionType.Linear);
    }

    /// <summary>
    /// Create an interpolating string animation.
    /// </summary>
    /// <param name="duration">The duration of the animation.</param>
    /// <returns></returns>
    public static UIAnimation InterpolatingSpring(double duration = 0.3)
    {
        return new UIAnimation(duration, Tween.EaseType.Out, Tween.TransitionType.Spring);
    }
}
