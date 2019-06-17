# mpcs51030-2019-winter-assignment-6-jarofmy

Mostly working.

Default album artwork is just a surprised pikachu. Album art loads as necessarily (i.e. not all at once.)

Used following resource to figure out how to set up delegate method: https://medium.com/ios-os-x-development/pass-data-with-delegation-in-swift-86f6bc5d0894

Some issues: Saving favorite items into new array and removing according to their isFavorite boolean works, however the indexing on "Favorite Items" does not match up. Once an item is moved, the index in the favorite view does not get reloaded, and so it thinks the items that were in index 0 are still the same names.

The detailed view, once accessed from the "Favorite Item" tab, does not presist with the "Filled in Heart", despite showing it on the collectionView.
