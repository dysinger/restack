open Lwt.Infix;

module Hello = (Time: Mirage_time.S) => {
  let start = _time => {
    let rec loop =
      fun
      | 0 => Lwt.return_unit
      | n => {
          Logs.info(f => f("hello"));
          Time.sleep_ns(Duration.of_sec(1)) >>= (() => loop(n - 1));
        };

    loop(4);
  };
};
