**update**: this repo is now obsolete since this functionality was long ago merged in [treeform/chroma](https://github.com/treeform/chroma/pull/14#event-3494305554). I will archive this. also note that color proximity test has been indeed [removed](https://github.com/github/linguist/pull/4978)

This repo implements the [ciede2000 color distance](https://en.wikipedia.org/wiki/Color_difference#CIEDE2000) function.
It is based on [[Sharma et al 2004]](http://www2.ece.rochester.edu/~gsharma/ciede2000/ciede2000noteCRNA.pdf), which also provides [test vectors](http://www2.ece.rochester.edu/~gsharma/ciede2000/).

One idea would be to use this to find what could be a valid color for a language in github/linguist, given the color proximity test.

[Color proximity test in linguist](https://github.com/github/linguist/blob/master/test/test_color_proximity.rb) is based on [color-proximity ruby gem](https://github.com/gjtorikian/color-proximity) which is based on [color_difference gem](https://github.com/mmozuras/color_difference/blob/master/lib/color_difference.rb) implementing color distance. Note that the color distance implemented in ruby scales the distance in the [0, 1] range by dividing the CIEDE2000 distance by 100 and clipping values to 100. Also note that color proximity test in linguist [might actually be removed in the future](https://github.com/github/linguist/pull/2298#issuecomment-597735376).
