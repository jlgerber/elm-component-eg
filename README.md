# Elm Component Example

Even though the Child Component Pattern (is it a first class thing? Well I capitalized the name so it must be ) in Elm has been cast in a negative light, it still seems to have its place. I don't really know why all of the examples were removed from Elm .18, but they were. This forced me to work through the exercise of (re)creating an example.

It turns out to be pretty simple once you wrap your head around it. Unfortunately, I had not seen a tutorial / example targetted towards this.

# When to use this Pattern?
As the community points out, this is not the pattern to reach for at first. If you can avoid the complexity, then do so. However, if you are creating a package, then you might have no choice. Especially if you want to provide subscriptions and/or updates and make child messages opaque. This does NOT mean that the package retains state. State should reside in the root model. 