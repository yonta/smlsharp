(**
 *
 * @author UENO Katsuhiro
 * @version $Id: PrimitiveTable.sml,v 1.12 2007/01/23 03:25:16 kiyoshiy Exp $
 *)
structure PrimitiveTable :> PRIMITIVE_TABLE =
struct

  (***************************************************************************)

  structure U = Utility

  (***************************************************************************)

  datatype primitive = Internal of string | External of int * string | None

  type spec =
       {
         bindName : string,
         alias : string,
         typeSpec : string,
         arity : int,
         primitive : primitive
       }

  (***************************************************************************)

  exception ParseError of int

  (***************************************************************************)

  (**
   *  The least index of primitivies
   *  This value may be changed in future when some reserve primitives are
   * introduced.
   *)
  val initialPrimitiveIndex = 0

  fun input filename =
      let
        val input = TextIO.getInstream (TextIO.openIn(filename))
        val CSV =
            CSVParser.parse (U.skipCommentParser TextIO.StreamIO.input1) input
        val _ = TextIO.StreamIO.closeIn input

        fun parse (line, {lineno, index, dst}) =
            case line : CSVParser.field list of
              [SOME func, aliasOpt, SOME ty, SOME arity, SOME prim, NONE] =>
              {
                lineno = lineno + 1,
                index = index,
                dst =
                {
                  bindName = #1 func,
                  alias = #1(Option.getOpt(aliasOpt, func)),
                  typeSpec = #1 ty,
                  arity = valOf (Int.fromString (#1 arity)),
                  primitive = Internal (#1 prim)
                } :: dst
              }
            | [SOME func, aliasOpt, SOME ty, SOME arity, NONE, SOME vmFunc] =>
              {
                lineno = lineno + 1,
                index = index + 1,
                dst =
                {
                  bindName = #1 func,
                  alias = #1(Option.getOpt(aliasOpt, func)),
                  typeSpec = #1 ty,
                  arity = valOf (Int.fromString (#1 arity)),
                  primitive = External (index, (#1 vmFunc))
                } :: dst
              }
            | [SOME func, aliasOpt, SOME ty, SOME arity, NONE, NONE] =>
              {
                lineno = lineno + 1,
                index = index,
                dst =
                {
                  bindName = #1 func,
                  alias = #1(Option.getOpt(aliasOpt, func)),
                  typeSpec = #1 ty,
                  arity = valOf (Int.fromString (#1 arity)),
                  primitive = None
                } :: dst
              }
            | [NONE] =>
              {
                lineno = lineno,
                index = index,
                dst = dst
              }
            | _ => raise (ParseError lineno)
      in
        rev
            (#dst
                 (foldl
                      parse
                      {lineno = 1, index = initialPrimitiveIndex, dst = nil}
                      CSV))
      end

  fun join s ("", s2) = s2
    | join s (s1, s2) = s1 ^ s ^ s2

  fun primitiveTypesSML spec =
      let
        fun format (dst, nil) = dst
          | format (dst, ({alias, typeSpec, ...} : spec) :: t) =
            let
              val code =
                  "val " ^ alias ^ "Ty = "
                  ^ "TypeParser.readTy PredefinedTypes.initialTyConEnv "
                  ^ "\"" ^ typeSpec ^ "\" "
            in
              format (join "\n" (dst, code), t)
            end
      in
        format ("", spec)
      end

  fun primitiveInfosSML spec =
      let
        fun format (dst, nil) = dst
          | format (dst, ({bindName, alias, ...} : spec) :: t) =
            let
              val code =
                  "val " ^ alias ^ "PrimInfo = "
                  ^ "{name = \"" ^ bindName ^ "\", "
                  ^ "ty = " ^ alias ^ "Ty}"
            in
              format (join "\n" (dst, code), t)
            end
      in
        format ("", spec)
      end

  fun primitivesSML spec =
      let
        fun format (dst, nil) = dst
          | format (dst, {bindName, alias, typeSpec, arity, primitive}::t) =
            let
              val instruction =
                  case (arity, primitive) of
                    (1, Internal opcode) => "Internal1 " ^ opcode
                  | (2, Internal opcode) => "Internal2 " ^ opcode
                  | (3, Internal opcode) => "Internal3 " ^ opcode
                  | (_, Internal opcode) => "InternalN " ^ opcode
                  | (_, External (index, _)) =>
                    "External " ^ Int.toString index
                  | (_, None) => "None"
              val code =
                  "{bindName = \"" ^ bindName ^ "\", "
                  ^ "ty = " ^ alias ^ "Ty, "
                  ^ "instruction = " ^ instruction ^ "}"
            in
              format (join ",\n" (dst, code), t)
            end
      in
        format ("", spec)
      end

  fun instructionsSML spec =
      let
        fun format (dst, nil : spec list) = dst
          | format (dst, {primitive = External _, ...} :: t) = format (dst, t)
          | format (dst, {primitive = None, ...} :: t) = format (dst, t)
          | format (dst, {arity, primitive = Internal opcode, ...} :: t) =
            let
              val operand = 
                  case arity of
                    1 =>
                    "{argIndex : UInt32, destination : UInt32}"
                  | 2 =>
                    "{argIndex1 : UInt32, \
                    \argIndex2 : UInt32, destination : UInt32}"
                  | 3 =>
                    "{argIndex1 : UInt32, \
                    \argIndex2 : UInt32, argIndex3 : UInt32, \
                    \destination : UInt32}"
                  | _ =>
                    "{argsCount : UInt32, " ^
                    "argIndexes : UInt32 list, destination : UInt32}"
              val code = "        | " ^ opcode ^ " of " ^ operand
            in
              format (join "\n" (dst, code), t)
            end
      in
        format ("", spec)
      end

  fun primitivesListC (spec : spec list) =
      let
        fun format (dst, nil : spec list) = dst
          | format (dst, {primitive = Internal _, ...} :: t) = format (dst, t)
          | format (dst, {primitive = None, ...} :: t) = format (dst, t)
          | format
                (dst, {primitive = External (_, functionName), ...} :: t) =
            let
              val code = functionName
            in
              format (join ",\n" (dst, code), t)
            end
      in
        format ("", spec)
      end

  fun primitiveDeclarationsC (spec : spec list) =
      let
        fun format (dst, nil : spec list) = dst
          | format (dst, {primitive = Internal _, ...} :: t) = format (dst, t)
          | format (dst, {primitive = None, ...} :: t) = format (dst, t)
          | format (dst, {primitive = External (_, functionName), ...} :: t) =
            let
              val code = "extern Primitive " ^ functionName ^ ";"
            in
              format (join "\n" (dst, code), t)
            end
      in
        format ("", spec)
      end

  fun formatTemplate (spec, inFilename, outFilename) =
      let
        val infile = TextIO.openIn inFilename
        val outfile = TextIO.openOut outFilename
        fun replaceLabel x =
            case Substring.string x of
              "SMLPrimitives" => SOME (primitivesSML spec)
            | "SMLPrimitiveTypes" => SOME (primitiveTypesSML spec)
            | "SMLPrimitiveInfos" => SOME (primitiveInfosSML spec)
            | "SMLPrimitiveInstructions" => SOME (instructionsSML spec)
            | "CPrimitivesList"  => SOME (primitivesListC spec)
            | "CPrimitiveDeclarations"  => SOME (primitiveDeclarationsC spec)
            | _ => NONE
      in
        AtmarkTemplate.format replaceLabel (infile, outfile) ;
        TextIO.closeOut outfile ;
        TextIO.closeIn infile
      end

  fun generateFiles inputFile outputFiles =
      let
        val spec = input inputFile
      in
        foldl
            (fn (filename, _) =>
                formatTemplate (spec, filename ^ ".in", filename))
            ()
            outputFiles
      end

  (***************************************************************************)

end