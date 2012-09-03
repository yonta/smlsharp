(**
 * qsort.sml - sample program using FFI
 *
 * @copyright (c) 2006-2007, Tohoku University.
 * @author UENO Katsuhiro
 * @version $Id: qsort.sml,v 1.7.2.1 2007/03/26 06:26:50 katsu Exp $
 *)

val libc = "/lib/libc.so.6"
(*
val libc = "/usr/lib/libc.dylib"  (* Mac OS X *)
*)
(*
use "cconfig.sml";
val libc = valOf (CConfig.findLibrary("c","qsort",["stdlib.h"]));
*)

val libc = DynamicLink.dlopen libc
val c_qsort = DynamicLink.dlsym (libc, "qsort")
fun qsort (a, f) =
    _ffiapply c_qsort (a : 'a array,
                       Array.length a : int,
                       _sizeof('a),
                       f : ('a ptr, 'a ptr) -> int) : unit

fun printIntAry x = (Array.app (fn x => print (" " ^ Int.toString x)) x;
                     print "\n")
fun printRealAry x = (Array.app (fn x => print (" " ^ Real.toString x)) x;
                      print "\n")

val a = Array.fromList [4,75,14,2147483647,3,6,423,42,~2147483648,8,2]
val b = Array.fromList [2.3, 1.1, 0.2,10.5,~12.0]

val _ = printIntAry a
val _ = printRealAry b

fun compareInt (p1, p2) =
    let
      val n1 = !!p1 : int
      val n2 = !!p2
    in
      if n1 > n2 then 1 else if n1 < n2 then ~1 else 0
    end

fun compareReal (p1, p2) =
    let
      val n1 = !!p1 : real
      val n2 = !!p2
    in
      if n1 > n2 then 1 else if n1 < n2 then ~1 else 0
    end

val _ = qsort (a, compareInt)
val _ = qsort (b, compareReal)

val _ = printIntAry a
val _ = printRealAry b
