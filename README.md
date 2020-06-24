
This repo implements the [ciede2000 color distance](https://en.wikipedia.org/wiki/Color_difference#CIEDE2000) function.
It is based on [[Sharma et al 2004]](http://www2.ece.rochester.edu/~gsharma/ciede2000/ciede2000noteCRNA.pdf), which also provides [test vectors](http://www2.ece.rochester.edu/~gsharma/ciede2000/).

One idea would be to use this to find what could be a valid color for a language in github/linguist, given the color proximity test.

[Color proximity test in linguist](https://github.com/github/linguist/blob/master/test/test_color_proximity.rb) is based on [color-proximity ruby gem](https://github.com/gjtorikian/color-proximity) which is based on [color_difference gem](https://github.com/mmozuras/color_difference/blob/master/lib/color_difference.rb) implementing color distance. Note that the color distance implemented in ruby scales the distance in the [0, 1] range by dividing the CIEDE2000 distance by 100 and clipping values to 100. Also note that color proximity test in linguist [might actually be removed in the future](https://github.com/github/linguist/pull/2298#issuecomment-597735376).

Currently, the implementation passes correctly the test vectors and [this color proximity failing test between Dafny and Nim](https://github.com/github/linguist/pull/4866) but I am not able to reproduce the example usage from color-proximity README.
My guess is there is something different either in how ruby gem converts RGB to LAB or in how color distance is implemented in ruby gem. Or amybe it is something very basic I am missing at the moment.
