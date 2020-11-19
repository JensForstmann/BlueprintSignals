# Blueprint Signals  
[CHANGELOG](changelog.txt) | [MIT License](LICENSE) | https://github.com/Haxtorio/BlueprintSignals  

Blueprint Signals will read a blueprint and convert it to a set of constant combinators containing
the signals and values of the blueprint items. The combinators can then be connected to a circuit
or logistic network to request the blueprint items for construction.

This is an addon mod that fully integrates with [Blueprint Extensions](https://mods.factorio.com/mod/BlueprintExtensions) if it is installed.
It will also work fine as a stand-alone mod if you don't have or want Blueprint Extensions.


## Instructions  
While holding a valid blueprint (that is not empty), press `CTRL+ALT+S` to convert it.  
A new blueprint containing one or more constant combinators will be generated, holding all the
unique signals for the blueprint items and counts.

## Contact
If you encounter a bug or have a suggestion, please [submit an issue on github]().  



## Credits  
  - deniwiaid (author of BlueprintExtensions)  
    I ripped a lot of the code for this mod from bpex and learned from the rest.
  - thanks to smartguy1196 for fixing a crash when creating a new blueprint book n empty book.
