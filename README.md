This is a progression of the original mod ["BlueprintSignals" by GaticusHax](https://mods.factorio.com/mod/BlueprintSignals).

Since the author is absent and I improved the mod a bit but no new version got released, I release it here.
See below for a list of changes compared to the original mod.



# Blueprint Signals (continued)

Blueprint Signals will read a blueprint (or book) and convert it to a set of constant combinators containing
the items to build the blueprint (or book) as signals. The combinators can then be connected to a circuit
or logistic network to request the blueprint items for construction.



## Instructions for a single blueprint

![Shortcut button: Convert blueprint](graphics/icon-bp-64.png)

While holding a blueprint (or book), press `CTRL+ALT+S` (configurable) to convert it.
Alternatively press the shortcut button while holding the blueprint.

A new blueprint containing one or more constant combinators will be generated, holding all the
unique signals for the blueprint items and counts. If holding a blueprint book, this will also work
and will only convert the active selected blueprint.



## Instructions for a complete blueprint book

![Shortcut button: Convert blueprint book](graphics/icon-bp-book-64.png)

Works the same way as for a single blueprint, but the key sequence is `CTRL+SHIFT+ALT+S` (configurable). 
Alternatively press the shortcut button while holding the blueprint book.

Instead of converting only the active blueprint it will convert all blueprints and nested books.



## Settings

Mod settings:
- Create temporary/persistent blueprint
- Limit the number of signals per constant combinator
- Connect multiple constant combinators with red and/or green wires

Control settings:
- Hotkey to convert a single blueprint
- Hotkey to convert a complete blueprint book



## Changes compared to the original mod

- Add support to convert complete blueprint books
- Updated for Factorio 2.0
- Add module support
- Add config to limit signal count per combinator
- Fix missing signals in some cases



## Contact

If you encounter a bug or have a suggestion, please [submit an issue on github](https://github.com/JensForstmann/BlueprintSignals/issues)
or [open a discussion on the mod portal](https://mods.factorio.com/mod/BlueprintSignals_continued/discussion).
