This is a progression of the original mod ["BlueprintSignals" by GaticusHax](https://mods.factorio.com/mod/BlueprintSignals).

Since the author is absent and I improved the mod a bit but no new version got released, I release it here. See below for a list of changes compared to the original mod.


# Blueprint Signals (continued)

Blueprint Signals will read a blueprint and convert it to a set of constant combinators containing
the signals and values of the blueprint items. The combinators can then be connected to a circuit
or logistic network to request the blueprint items for construction.

This is an addon mod that fully integrates with [Blueprint Extensions (Kux Edition)](https://mods.factorio.com/mod/Kux-BlueprintExtensions) if it is installed.
It will also work fine as a stand-alone mod if you don't have or want Blueprint Extensions.


## Instructions
While holding a valid blueprint (that is not empty), press `CTRL+ALT+S` to convert it.
A new blueprint containing one or more constant combinators will be generated, holding all the
unique signals for the blueprint items and counts.


## Changes compared to the original mod
- Add module support
- Add config to limit signal count per combinator
- Fix missing signals in some cases


## Contact
If you encounter a bug or have a suggestion, please [submit an issue on github](https://github.com/JensForstmann/BlueprintSignals/issues).


## Credits
- GaticusHax (author of the [original mod](https://mods.factorio.com/mod/BlueprintSignals))
- deniwiaid (author of BlueprintExtensions), I ripped a lot of the code for this mod from bpex and learned from the rest.
- thanks to smartguy1196 for fixing a crash when creating a new blueprint book.
