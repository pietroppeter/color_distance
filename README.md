* based on this ruby gem: https://github.com/mmozuras/color_difference/blob/master/lib/color_difference.rb
* which is based on this formula: http://www2.ece.rochester.edu/~gsharma/ciede2000/ciede2000noteCRNA.pdf (test vectors [here](http://www2.ece.rochester.edu/~gsharma/ciede2000/), see also [wikipedia](https://en.wikipedia.org/wiki/Color_difference#CIEDE2000))
* that ruby gem is used in [this other ruby gem](https://github.com/gjtorikian/color-proximity) which is used in [color proximity test](https://github.com/github/linguist/blob/master/test/test_color_proximity.rb) of linguist
* goal: add post with info on nim forum: https://forum.nim-lang.org/t/6350
* bonus: implement a UI for testing color pxomity against linguist colors (https://github.com/github/linguist/blob/master/lib/linguist/languages.yml)
* bonus 2: PR implement color difference formula for Chroma? https://github.com/treeform/chroma/blob/master/src/chroma/colortypes.nim
* bonus 3: how to find closest available color in linguist?
