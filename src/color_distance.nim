import chroma, math
when defined(debugDeltaE00):
  import sugar  # only used for dump when debugging

const twentyfiveToSeventh = (25^7).float32

proc myAtan(x, y: float32): float32 =
  if x == 0 and y == 0:
    return 0
  elif x >= 0:
    arctan2(x, y).radToDeg
  else:
    arctan2(x, y).radToDeg + 360

func deltaE00*(c1, c2: ColorLAB, k_L, k_C, k_H = 1.float32): float32 =
  let
    C1 = sqrt(c1.a^2 + c1.b^2)  # C1 and C2 are only used in computation of CM, we can remove them (or rename them C1star)
    C2 = sqrt(c2.a^2 + c2.b^2)
    CM = 0.5*(C1 + C2)
    CM7 = CM^7
    G = 0.5*(1 - sqrt(CM7 / (CM7 + twentyfiveToSeventh)))
    # aa1 is c1.a prime
    aa1 = (1 + G)*c1.a
    aa2 = (1 + G)*c2.a
    CC1 = sqrt(aa1^2 + c1.b^2)
    CC2 = sqrt(aa2^2 + c2.b^2)
    h1 = myAtan(c1.b, aa1)
    h2 = myAtan(c2.b, aa2)
    deltaL = c2.l - c1.l
    deltaCC = CC2 - CC1
    deltah =
      if CC1 == 0 or CC2 == 0:
        0.float32
      elif abs(h2 - h1) <= 180:
        h2 - h1
      elif h2 - h1 > 180:
        h2 - h1 - 360
      else:
        h2 - h1 + 360
    deltaHH = 2*sqrt(CC1*CC2)*sin(degToRad(0.5*deltah))
    LM = 0.5*(c1.l + c2.l)
    CCM = 0.5*(CC1 + CC2)
    hM =
      if CC1 == 0 or CC2 == 0:
        h1 + h2
      elif abs(h2 - h1) <= 180:
        0.5*(h1 + h2)
      elif h2 - h1 > 180:
        0.5*(h1 + h2 + 360)
      else:
        0.5*(h1 + h2 - 360)
    T = 1 - 0.17*cos(degToRad(hM - 30)) + 0.24*cos(degToRad(2*hM)) + 0.32*cos(degToRad(3*hM + 6)) - 0.20*cos(degToRad(4*hM - 63))
    deltaTheta = 30*exp(-1*((hM - 275) / 25)^2)
    R_C = 2*sqrt(CCM^7 / (CCM^7 + twentyfiveToSeventh))
    S_L = 1 + (0.015*(LM - 50)^2)/sqrt(20 + (LM - 50)^2)
    S_C = 1 + 0.045*CCM
    S_H = 1 + 0.015*CCM*T
    R_T = -sin(degToRad(2*deltaTheta))*R_C
  result = sqrt((deltaL/(k_L*S_L))^2 + (deltaCC/(k_C*S_C))^2 + (deltaHH/(k_H*S_H))^2 + R_T*(deltaCC / (k_C*S_C))*(deltaHH/(k_H*S_H)))
  when defined(debugDeltaE00):
    dump c1
    dump c2
    dump C1
    dump C2
    dump CM
    dump G
    dump aa1
    dump aa2
    dump CC1
    dump CC2
    dump h1
    dump h2
    dump deltah
    dump deltaL
    dump deltaCC
    dump deltaHH
    dump LM
    dump CCM
    dump hM
    dump T
    dump deltaTheta
    dump R_C
    dump S_L
    dump S_C
    dump S_H
    dump R_T
    dump deltaL/(k_L*S_L)
    dump deltaCC/(k_C*S_C)
    dump (deltaHH/(k_H*S_H))
    dump result

func deltaE00*(c1, c2: string): float32 =
  deltaE00(parseHex(c1).lab, parseHex(c2).lab)

when isMainModule:
  import unittest, parsecsv, strutils

  template checkAlmostEqual(x, y: float32, epsilon=0.0001): untyped =
    check abs(x - y) < epsilon

  test "test vectors for deltaE00":
    var x: CsvParser
    x.open("tests/test_vectors.csv")
    x.readHeaderRow()
    assert x.headers == @["c1l", "c1a", "c1b", "c2l", "c2a", "c2b", "deltaE00"]
    var c1, c2: ColorLAB
    var expectedResult, result: float32
    while readRow(x):
      echo "test vector #", x.processedRows - 1  # first row is header
      c1 = lab(x.rowEntry("c1l").parseFloat.float32, x.rowEntry("c1a").parseFloat.float32, x.rowEntry("c1b").parseFloat.float32)
      c2 = lab(x.rowEntry("c2l").parseFloat.float32, x.rowEntry("c2a").parseFloat.float32, x.rowEntry("c2b").parseFloat.float32)
      expectedResult = x.rowEntry("deltaE00").parseFloat.float32
      result = deltaE00(c1, c2)
      echo "\tc1: ", c1
      echo "\tc2: ", c2
      echo "\texpect: ", expectedResult
      echo "\tresult: ", result
      checkAlmostEqual(expectedResult, result)
  test "examples from color-proximity ruby gem README":
    let
      c0 = "000003"
      c1 = "000001"
      c2 = "000002"
      c3 = "ffffff"
      res1 = deltaE00(c0, c1) / 100.0
      res2 = deltaE00(c0, c2) / 100.0
      res3 = deltaE00(c0, c3) / 100.0
      expRes1 = 0.00832.float32
      expRes2 = 0.00412.float32
      expRes3 = 0.99948.float32
    echo "Distances between c0 and c_i with i = 1, 2, 3"
    echo "\tc0: ", c0
    echo "\tc1: ", c1
    echo "\tc2: ", c2
    echo "\tc3: ", c3
    echo "\t(c0, c1): ", res1
    echo "\texpected: ", expRes1
    echo "\t(c0, c2): ", res2
    echo "\texpected: ", expRes2
    echo "\t(c0, c3): ", res3
    echo "\texpected: ", expRes3
    checkAlmostEqual(res1, expRes1)
    checkAlmostEqual(res2, expRes2)
    checkAlmostEqual(res3, expRes3)
  test "example of proximity failures":
    let
      c1 = "FFDF00"
      c2 = "FFEC25"
      result = deltaE00(c1, c2) / 100  # color distance ruby gem does scale between 0 and 1 (cytting off all values > 100)
    echo "Nim (c1) against Dafny (c2)"
    echo "\tc1: ", c1
    echo "\tc2: ", c2
    echo "\tresult: ", result
    check result < 0.05  # proximity threshold set in linguist
