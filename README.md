# mastermind
Mastermind project for Odin project. This one made me struggle a few times.

Again, I didn't look up any samples. I only looked up informations about the game and troubleshoots for some errors.

I learned that classes aren't fully initialized until the initialize method finished and that .map/.each/etc struggle with removing
items while still looping. Also that instanced arrays are annoying. (needed .dup alot)

Also, I think it couldn't handle 4k+ arrays in an array, thus I resorted to String.split.to_i for the 
computer class sample calculation. (After mapping the main array, the entrys ended up being really faulty [nil,1,nil,3] or even [1,6] 
instead of the usual 4 length). 
I didn't minmax the samples for the computer code. Random picking works well enough.

All in all took me about 4 days to finish

