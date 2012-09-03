structure MBString = MultiByteString.String;
structure MBChar = MultiByteString.Char;
type char = MBChar.char;
type string = MBString.string;
type substring = MBSubstring.substring;
val ord = MBChar.ord;
val chr = MBChar.chr;
val op ^ = MBString.^;
val concat = MBString.concat;
val explode = MBString.explode;
val implode = MBString.implode;
val size = MBString.size;
val sub = MBString.sub;
val substring = MBString.substring;
