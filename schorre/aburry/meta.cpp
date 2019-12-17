#include <meta.h>
def(out1)
def(output)
def(ex3)
def(ex2)
def(ex1)
def(st)
def(preamble)
def(program)
adr(program)
sub(out1)
  lgn
  tst("*1")
  bf(a00000)
  cl("  gn1")
  out
a00000:
  bt(a00001)
  tst("*")
  bf(a00002)
  cl("  ci")
  out
a00002:
  bt(a00001)
  sr
  bf(a00003)
  cl("  cl(")
  ci
  cl(")")
  out
a00003:
a00001:
  ret
sub(output)
  lgn
  tst(".out")
  bf(a00004)
  tst("(")
  be
a00005:
  cll(out1)
  bt(a00005)
  set
  be
  tst(")")
  be
  cl("  out")
  out
a00004:
a00006:
  ret
sub(ex3)
  lgn
  id
  bf(a00007)
  cl("  cll(")
  ci
  cl(")")
  out
a00007:
  bt(a00008)
  sr
  bf(a00009)
  cl("  tst(")
  ci
  cl(")")
  out
a00009:
  bt(a00008)
  tst(".id")
  bf(a00010)
  cl("  id")
  out
a00010:
  bt(a00008)
  tst(".string")
  bf(a00011)
  cl("  sr")
  out
a00011:
  bt(a00008)
  tst("(")
  bf(a00012)
  cll(ex1)
  be
  tst(")")
  be
a00012:
  bt(a00008)
  tst("$")
  bf(a00013)
  gn1
  cl(":")
  out
  cll(ex3)
  be
  cl("  bt(")
  gn1
  cl(")")
  out
  cl("  set")
  out
a00013:
a00008:
  ret
sub(ex2)
  lgn
  cll(ex3)
  bf(a00014)
  cl("  bf(")
  gn1
  cl(")")
  out
a00014:
  bt(a00015)
  cll(output)
  bf(a00016)
a00016:
a00015:
  bf(a00017)
a00018:
  cll(ex3)
  bf(a00019)
  cl("  be")
  out
a00019:
  bt(a00020)
  cll(output)
  bf(a00021)
a00021:
a00020:
  bt(a00018)
  set
  be
  gn1
  cl(":")
  out
a00017:
a00022:
  ret
sub(ex1)
  lgn
  cll(ex2)
  bf(a00023)
a00024:
  tst("/")
  bf(a00025)
  cl("  bt(")
  gn1
  cl(")")
  out
  cll(ex2)
  be
a00025:
a00026:
  bt(a00024)
  set
  be
  gn1
  cl(":")
  out
a00023:
a00027:
  ret
sub(st)
  lgn
  id
  bf(a00028)
  cl("sub(")
  ci
  cl(")")
  out
  cl("  lgn")
  out
  tst("=")
  be
  cll(ex1)
  be
  tst(";")
  be
  cl("  ret")
  out
a00028:
a00029:
  ret
sub(preamble)
  lgn
  tst(".declare")
  bf(a00030)
a00031:
  id
  bf(a00032)
  cl("def(")
  ci
  cl(")")
  out
a00032:
a00033:
  bt(a00031)
  set
  be
  tst(".syntax")
  be
  id
  be
  cl("adr(")
  ci
  cl(")")
  out
a00030:
a00034:
  ret
sub(program)
  lgn
  cl("#include <meta.h>")
  out
  cll(preamble)
  be
a00035:
  cll(st)
  bt(a00035)
  set
  be
  tst(".end")
  be
a00036:
a00037:
  ret
