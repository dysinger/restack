let src = Logs.Src.create("http", ~doc="HTTP server");
module Log = (val (Logs.src_log(src): (module Logs.LOG)));

module Dispatch = (Clock: Mirage_clock.PCLOCK, Server: Cohttp_lwt.S.Server) => {
  let serve = clock => {
    let callback = ((_, cid), _request, _body) => {
      let time = Clock.now_d_ps(clock) |> Ptime.v;
      Log.info(f => f("responding to %s", Cohttp.Connection.to_string(cid)));
      let headers = Cohttp.Header.init_with("content-type", "application/json")
      and body = Format.asprintf("{ \"time\": \"%a\" }", Ptime.pp_human(), time);
      Server.respond_string(~status=`OK, ~headers, ~body, ());
    };
    Server.make(~callback, ());
  };
};

module HTTP = (Clock: Mirage_clock.PCLOCK, Server: Cohttp_lwt.S.Server) => {
  let start = (clock, http) => {
    let rec port = Key_gen.port()
    and tcp = `TCP(port);
    Log.info(f => f("listening on %d/TCP", port));
    module D = Dispatch(Clock, Server);
    http(tcp) @@ D.serve(clock);
  };
};
