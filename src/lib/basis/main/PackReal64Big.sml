(**
 * packing real value in big-endian byte order.
 * @author YAMATODANI Kiyoshi
 * @version $Id: PackReal64Big.sml,v 1.1 2007/03/08 08:07:00 kiyoshiy Exp $
 *)
structure PackReal64Big =
          PackReal64Base(struct
                           val isBigEndian = true
                           val unpack = Pack_unpackReal64Big
                           val pack = Pack_packReal64Big
                         end);
