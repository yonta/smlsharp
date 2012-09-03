(**
 * @copyright (c) 2006, Tohoku University.
 * @author OSAKA Satoshi
 * @version $Id: MatchData.sml,v 1.9 2007/02/11 16:39:51 kiyoshiy Exp $
 *)
structure MatchData = 
struct
  structure CT = ConstantTerm
  structure T = Types
  structure TFC = TypedFlatCalc
  structure VIdMap = TypedFlatCalcUtils.VIdEnv

  datatype kind = Bind | Match | Handle of TFC.varIdInfo
    
  type con = ConstantTerm.constant
  type tag = T.conInfo


  structure ConOrd : ordsig = 
  struct
    type ord_key = con
    fun compare (CT.INT i1, CT.INT i2) = Int32.compare (i1, i2)
      | compare (CT.WORD w1, CT.WORD w2) = Word32.compare (w1, w2)
      | compare (CT.STRING s1, CT.STRING s2) = String.compare (s1, s2)
      | compare (CT.REAL r1, CT.REAL r2) = String.compare (r1, r2)
      | compare (CT.FLOAT r1, CT.FLOAT r2) = String.compare (r1, r2)
      | compare (CT.CHAR c1, CT.CHAR c2) = Char.compare (c1, c2)
      | compare (CT.INT _, _) = LESS
      | compare (CT.STRING _, CT.REAL _) = LESS
      | compare (_, _) = GREATER
  end

  structure TagOrd : ordsig = 
   (* Ohori: I will double check to make sure that this is should be OK.
        structure TagOrd : ordsig = 
         struct
          type ord_key = tag * bool
       fun compare ((i, _) : ord_key, (k, _) : ord_key) = 
           ID.compare (#id i, #id k)
     end
   *)
  struct
    type ord_key = tag * bool
    fun compare ((i, _) : ord_key, (k, _) : ord_key) = 
        Int.compare (#tag i, #tag k)
  end


  structure SSOrd : ordsig = 
  struct
    type ord_key = string * string
    fun compare ((a1, l1), (a2, l2)) = 
        case String.compare (a1, a2)
	of EQUAL => String.compare (l1, l2)
         | ord => ord
  end

  structure ConMap = BinaryMapFn (ConOrd)
  structure TagMap = BinaryMapFn (TagOrd)
  structure SSMap = BinaryMapFn (SSOrd)

  type branchId = int

  datatype pat
  = WildPat of T.ty
  | VarPat of TFC.varIdInfo
  | ConPat of con * T.ty
  | TagPat of tag * bool * pat * T.ty
  | RecPat of (string * pat) list * T.ty
  | LayerPat of pat * pat
  | OrPat of pat * pat

 type exp = branchId

  datatype rule
  = End of exp
  | ++ of pat * rule
  infixr ++

  type env = TFC.varIdInfo VIdMap.map

  datatype tree
  = EmptyNode
  | LeafNode of exp * env
  | EqNode of TFC.varIdInfo * tree ConMap.map * tree
  | TagNode of TFC.varIdInfo * tree TagMap.map * tree
  | RecNode of TFC.varIdInfo * string * tree
  | UnivNode of TFC.varIdInfo * tree

  val unitExp = RecordCalc.RCCONSTANT(CT.UNIT, Loc.noloc)

  val expDummy = unitExp
    
end
