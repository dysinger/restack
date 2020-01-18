open Mirage

let server =
  cohttp_server @@ conduit_direct ~tls:false (socket_stackv4 [Ipaddr.V4.any])

let main =
  let packages = [ package "reason" ] in
  let port =
    let doc = Key.Arg.info ~doc:"Listening HTTP port." ["port"] in
    Key.(create "port" Arg.(opt int 80 doc)) in
  let keys = List.map Key.abstract [ port ] in
  foreign
    ~packages ~keys
    "Unikernel.HTTP" (pclock @-> http @-> job)

let () =
  register "webserver" [main $ default_posix_clock $ server]
