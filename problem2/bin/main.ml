open Core
open Lib

let test0 () =
  let transitions =
    [|
      [| 2; 0; |];
      [| 1; 1; |];
      [| 2; 1; |];
    |]
  in
  let dfa =
    { Dfa.n = 3;
      symbols = Set.of_sorted_array_unchecked (module Dfa.Symbol) [| '0'; '1'; |];
      transition = (fun state symbol -> transitions.(state).(Dfa.Symbol.to_int symbol));
      final = Set.singleton (module Dfa.State) 1;
    }
  in
  match Dfa.shortest_accepted_string dfa with
  | Some path -> Stdio.print_endline path (* expect 01 *)
  | None -> Stdio.print_endline "no path"

let test1 () =
  let dfa = Dfa.accept_decimal_multiples_of 10 in
  match Dfa.shortest_accepted_string dfa with
  | Some w -> Stdio.print_endline w (* expect 0 *)
  | None -> Stdio.print_endline "unreachable"

let test2 () =
  let k = 26147
  and digits = Set.of_sorted_array_unchecked (module Dfa.Symbol) [| '1'; '3'; |]
  in
  match Dfa.smallest_multiple k digits with
  | Some w -> Stdio.print_endline w (* expect 1113313113 *)
  | None -> Stdio.print_endline "unreachable"

let test3 () =
  let k = 198217
  and digits = Set.singleton (module Dfa.Symbol) '1'
  in
  match Dfa.smallest_multiple k digits with
  | Some w -> Stdio.print_endline w (* expect a string of 10962 1's *)
  | None -> Stdio.print_endline "unreachable"

let tests () =
  test0 ();
  test1 ();
  test2 ();
  test3 ()

let test =
  Command.basic
    ~summary:"Run the built-in test functions"
    (Command.Param.return tests)

let parse_digits digits =
  digits
  |> List.filter ~f:Char.is_digit
  |> Set.of_list (module Dfa.Symbol)

let smallest_multiple =
  let open Command.Let_syntax in
  Command.basic
    ~summary:"Find the smallest multiple of a given integer [k] using only the given digits [digit ...]"
    [%map_open
      let k = anon ("k" %: int)
      and digits = anon (sequence ("digit" %: char))
      in
      fun () ->
        (match Dfa.smallest_multiple k (parse_digits digits) with
         | Some w -> w
         | None -> "impossible")
        |> Stdio.print_endline
    ]

(* entry point *)
let () =
  Command.group
    ~summary:"CS454 Fall 2018 Project 1 Problem 2"
    [ "test", test;
      "smallest-multiple", smallest_multiple ]
  |> Command.run
