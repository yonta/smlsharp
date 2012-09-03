(**
 * ML parser.
 *
 * @author OHORI Atsushi
 * @author YAMATODANI Kiyoshi
 * @version $Id: Parser.sml,v 1.16 2006/12/22 10:21:06 katsu Exp $
 *)
structure Parser :> PARSER =
struct

  (***************************************************************************)

  structure CoreMLLrVals = CoreMLLrValsFun(structure Token = LrParser.Token)

  structure CoreMLLex = CoreMLLexFun(structure Tokens = CoreMLLrVals.Tokens)
  structure CoreMLParser : ARG_PARSER =
  JoinWithArg(structure ParserData = CoreMLLrVals.ParserData
              structure Lex = CoreMLLex
              structure LrParser = LrParser)

  structure PC = ParserConstants

  (***************************************************************************)

  type lexer =
         (CoreMLParser.svalue, CoreMLParser.pos)
             CoreMLParser.Token.token CoreMLParser.Stream.stream

  type context =
       {
         lexArg : CoreMLParser.lexarg,
         getLine : int -> string,
         lexer : lexer,
         onParseError : (string * Loc.pos * Loc.pos) -> unit
       }

  (***************************************************************************)

  exception  EndOfParse

  (* raised by lexer *)
  exception ParseError = CoreMLParser.ParseError

  (***************************************************************************)

  fun lineMapEntryToString {lineCount, beginPos} =
      "(" ^ Int.toString lineCount ^ ", " ^ Int.toString beginPos ^ ")"
  fun printLineMap lineMap =
      (
        print "lineMap = {";
        app (print o lineMapEntryToString) lineMap;
        print "}\n"
      )

  fun extendGetLine
          ({lineMap, lineCount, charCount, ...} : CoreMLParser.lexarg, getLine)
          num =
      let
        val line = getLine num
        val lineLength = String.size line
        val _= lineCount := (!lineCount) + 1
        val _= charCount := (!charCount) + lineLength
        val _=
            lineMap :=
            {lineCount = !lineCount, beginPos = !charCount} :: (!lineMap)
      in
        line
      end

  fun createContext {sourceName, onError, getLine, isPrelude} =
      let
        val lineCount = ref 1
        val charCount = ref PC.INITIAL_POS_OF_LEXER
        val lineMap = ref [{lineCount = 1, beginPos = !charCount}]
        val startPos = Loc.makePos {fileName = sourceName, line = 0, col = 0}
        val lexArg =
            {
              fileName = sourceName,
              isPrelude = isPrelude,
              errorPrinter = onError, (* not raise ParseError *)
              stringBuf = ref nil : string list ref,
              stringStart = ref startPos,
              stringType = ref true,
              comLevel = ref 0,
              anyErrors = ref false,
              lineMap = lineMap,
              lineCount = lineCount,
              charCount = charCount,
              initialCharCount = ! charCount - PC.INITIAL_POS_OF_LEXER
            } : CoreMLParser.lexarg
        val extendedGetLine = extendGetLine (lexArg, getLine)
        val lexer = (CoreMLParser.makeLexer extendedGetLine lexArg) : lexer
        val context =
            {
              lexArg = lexArg,
              getLine = extendedGetLine,
              lexer = lexer,
              onParseError = onError
            }
      in
        context
      end

  (**
   * refresh parser context.
   *)
  fun resumeContext ({lexArg, getLine, onParseError, ...} : context) =
      let
        val startPos =
            Loc.makePos {fileName = #fileName lexArg, line = 0, col = 0}
        val newLexArg =
            {
              fileName = #fileName lexArg,
              isPrelude = #isPrelude lexArg,
              errorPrinter = #errorPrinter lexArg,
              stringBuf = ref nil : string list ref,
              stringStart = ref startPos,
              stringType = ref true,
              comLevel = ref 0,
              anyErrors = ref false,
              lineMap = ref (!(#lineMap lexArg)),
              lineCount = ref (!(#lineCount lexArg)),
              charCount = ref (!(#charCount lexArg)),
              initialCharCount = !(#charCount lexArg) - PC.INITIAL_POS_OF_LEXER
            } : CoreMLParser.lexarg
        val extendedGetLine = extendGetLine (newLexArg, getLine)
        val lexer = (CoreMLParser.makeLexer extendedGetLine newLexArg) : lexer
        val context =
            {
              lexArg = newLexArg,
              getLine = getLine,
              lexer = lexer,
              onParseError = onParseError
            }
      in
        context
      end

  fun parse ({lexArg, getLine, lexer, onParseError, ...} : context) =
      let
        val dummyEOF = CoreMLLrVals.Tokens.EOF(Loc.nopos, Loc.nopos)
        val dummySEMICOLON =
            CoreMLLrVals.Tokens.SEMICOLON(Loc.nopos, Loc.nopos)

        fun parseImpl lexer =
            let
              val _ = (#anyErrors lexArg) := false
              (* look ahead one token. *)
              val (nextToken, lexer') = CoreMLParser.Stream.get lexer
            in
              (if CoreMLParser.sameToken(nextToken, dummyEOF)
               then raise EndOfParse
               else
                 if CoreMLParser.sameToken(nextToken, dummySEMICOLON)
                 then
                   (* look ahead one more token. *)
                   parseImpl lexer'
                 else
                   let
                     (* restart lex from the head token. *)
                     val (parseResult, lexer'') =
                         CoreMLParser.parse(0, lexer, onParseError, ())
                   in
                     if !(#anyErrors lexArg)
                     then raise ParseError
                     else
                       (
                         parseResult,
                         {
                           lexArg = lexArg,
                           getLine = getLine,
                           lexer = lexer'',
                           onParseError = onParseError
                         }
                       )
                   end)
            end
      in
        parseImpl lexer
      end

  fun errorToString (message, pos1, pos2) =
      String.concat 
          [
            Loc.fileNameOfPos pos1, ":",
            Int.toString (Loc.lineOfPos pos1),
            ".",
            Int.toString (Loc.colOfPos pos1),
            "-",
            Int.toString (Loc.lineOfPos pos2),
            ".",
            Int.toString (Loc.colOfPos pos2),
            " ",
            message,
            "\n"
          ]

  (***************************************************************************)

end