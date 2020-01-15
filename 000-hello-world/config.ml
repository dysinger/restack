open Mirage

let main =
  foreign
    ~packages:[ package "reason";
                package "duration"; ]
    "Unikernel.Hello" (time @-> job)

let () =
  register "hello" [main $ default_time]
