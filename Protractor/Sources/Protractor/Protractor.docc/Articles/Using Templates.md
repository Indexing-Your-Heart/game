# Using Templates

Provide a set of gestures that a recognizer can match against.

## Overview

Gesture recognizers rely on a set of templates, which provide the various gestures that a recognizer can match against.
Templates consist of the gesture's `name` and its vectorized `path`, which is typically already resampled, accounting
for orientation when necessary.

For example, the following template describes a simple rectangle:

```json
{
    "name": "rectangle",
    "path": [
        [78,149],[78,153],[78,157],[78,160],[79,162],[79,164],[79,167],
        [79,169],[79,173],[79,178],[79,183],[80,189],[80,193],[80,198],
        [80,202],[81,208],[81,210],[81,216],[82,222],[82,224],[82,227],
        [83,229],[83,231],[85,230],[88,232],[90,233],[92,232],[94,233],
        [99,232],[102,233],[106,233],[109,234],[117,235],[123,236],
        [126,236],[135,237],[142,238],[145,238],[152,238],[154,239],
        [165,238],[174,237],[179,236],[186,235],[191,235],[195,233],
        [197,233],[200,233],[201,235],[201,233],[199,231],[198,226],
        [198,220],[196,207],[195,195],[195,181],[195,173],[195,163],
        [194,155],[192,145],[192,143],[192,138],[191,135],[191,133],
        [191,130],[190,128],[188,129],[186,129],[181,132],[173,131],
        [162,131],[151,132],[149,132],[138,132],[136,132],[122,131],
        [120,131],[109,130],[107,130],[90,132],[81,133],[76,133]
    ]
}
```

Note that the `path` defined in this small JSON snippet contains a 2D array of coordinates, and not necessarily a list
of numbers.

## Creating a template file

A template file can be created as a JSON file with a root array of template structures such as the one listed above:

```json
[
    {
        "name": "rectangle",
        "path": [
            [78,149],[78,153],[78,157],[78,160],[79,162],[79,164],[79,167],
            [79,169],[79,173],[79,178],[79,183],[80,189],[80,193],[80,198],
            [80,202],[81,208],[81,210],[81,216],[82,222],[82,224],[82,227],
            [83,229],[83,231],[85,230],[88,232],[90,233],[92,232],[94,233],
            [99,232],[102,233],[106,233],[109,234],[117,235],[123,236],
            [126,236],[135,237],[142,238],[145,238],[152,238],[154,239],
            [165,238],[174,237],[179,236],[186,235],[191,235],[195,233],
            [197,233],[200,233],[201,235],[201,233],[199,231],[198,226],
            [198,220],[196,207],[195,195],[195,181],[195,173],[195,163],
            [194,155],[192,145],[192,143],[192,138],[191,135],[191,133],
            [191,130],[190,128],[188,129],[186,129],[181,132],[173,131],
            [162,131],[151,132],[149,132],[138,132],[136,132],[122,131],
            [120,131],[109,130],[107,130],[90,132],[81,133],[76,133]
        ]
    },
    ...
]
```

## Creating a template programmatically

Alternatively, you can write your own template programmatically using the ``ProtractorTemplate`` structure:

```swift
let points: [Double] = [78, 149, 78, 153, ...]
let template = ProtractorTemplate(name: "rectangle", vectorPath: points)
```

Note that ``ProtractorTemplate/vectorPath`` will already be flattened into an array of doubles for you.


## Adding templates to a recognizer

The ``ProtractorRecognizer`` provides a facility for adding templates for it to match against, both through a file and
programmatically.

To add an array of templates, call ``ProtractorRecognizer/insertTemplates(from:)``:

```swift
let template = ProtractorTemplate(name: "rectangle", vectorPath: points)
let allTemplates = [template, ...]

let recognizer = ProtractorRecognizer()
recognizer.insertTemplates(from: allTemplates)
```

If your templates reside in a bundle as a resource, call ``ProtractorRecognizer/insertTemplates(reading:in:)``:

```swift
let recognizer = ProtractorRecognizer()
do {
    try recognizer.insertTemplates(reading: "AllTemplates", in: Bundle.main)
} catch {
    print("Unable to add templates: \(error.localizedDescription)")
}
```
