include "basis/main/OS_FILE_SYS.sig"
include "basis/main/OS_IO.sig"
include "basis/main/OS_PATH.sig"
include "basis/main/OS_PROCESS.sig"

signature OS =
sig
  structure FileSys : OS_FILE_SYS
  structure IO : OS_IO
  structure Path : OS_PATH
  structure Process : OS_PROCESS
  eqtype syserror
  exception SysErr of string * syserror option
  val errorMsg : syserror -> string
  val errorName : syserror -> string
  val syserror : string -> syserror option
end
