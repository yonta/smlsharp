(**
 * implementation of channel using a client socket.
 * @copyright (c) 2006, Tohoku University.
 * @author YAMATODANI Kiyoshi
 * @version $Id: ClientSocketChannel.sml,v 1.7 2007/03/15 12:13:06 katsu Exp $
 *)
structure ClientSocketChannel =
struct

  (***************************************************************************)

  type InitialParameter =
       {
         (** name of the host to connect *)
         hostName : string,
         
         (** port number *)
         port : int
       }

  (***************************************************************************)

  exception AddressNotFound of string

  (***************************************************************************)

  fun openInOut ({hostName, port} : InitialParameter) =
      let
        fun send socket word =
            let
              val array = Word8Array.fromList [word]
              val sendBuffer = {buf = array, i = 0, sz = SOME 1}
            in
              Socket.sendArr (socket, sendBuffer);
              ()
            end
        fun sendArray socket array =
            let
              val sendBuffer = {buf = array, i = 0, sz = NONE}
            in
              (* Assume streaming socket; send(2) sends all data in array *)
              Socket.sendArr (socket, sendBuffer);
              ()
            end
        fun sendVector socket vector =
            let
              val sendBuffer = {buf = vector, i = 0, sz = NONE}
            in
              Socket.sendVec (socket, sendBuffer);
              ()
            end
        fun receive socket () =
            let
              val vector = Socket.recvVec (socket, 1)
            in
              if 0 = Word8Vector.length vector
              then NONE
              else SOME(Word8Vector.sub (vector, 0))
            end
        fun receiveArray socket bytes =
            let
              val array = Word8Array.array (bytes, 0w0)
              fun recv (array, i) =
                  if i >= Word8Array.length array then array
                  else
                    let
                      val buf = {buf = array, i = i, sz = NONE}
                      val n = Socket.recvArr (socket, buf)
                    in
                      if n = 0 then
                        let
                          val newArray = Word8Array.array (i, 0w0)
                        in
                          Word8Array.copy {src = array,
                                           si = 0,
                                           dst = newArray,
                                           di = 0,
                                           len = SOME i};
                          newArray
                        end
                      else recv (array, i + n)
                    end
            in
              recv (array, 0)
            end
        fun receiveVector socket bytes =
            Word8Array.extract (receiveArray socket bytes, 0, NONE)
        fun isEOF socket () = false
        fun flush () = ()
        fun close closed socket () =
            if !closed then () else (Socket.close socket; closed := true)

        val entry =
            case NetHostDB.getByName hostName of
              SOME(entry) => entry
            | NONE => raise AddressNotFound hostName
        val address = NetHostDB.addr entry
        val addressPortPair = INetSock.toAddr (address, port)
        val socket = INetSock.TCP.socket()
        val _ = Socket.connect (socket, addressPortPair)
        val closed = ref false
      in
        (
          {
            receive = receive socket,
            receiveArray = receiveArray socket,
            receiveVector = receiveVector socket,
            close = close closed socket,
            isEOF = isEOF socket
          } : ChannelTypes.InputChannel,
          {
            send = send socket,
            sendArray = sendArray socket,
            sendVector = sendVector socket,
            flush = flush,
            close = close closed socket
          } : ChannelTypes.OutputChannel
        )
      end

  (***************************************************************************)

end
