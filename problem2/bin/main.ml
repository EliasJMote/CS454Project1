open Base
open Lib

let () =
  let transitions =
    [|
      [| 2; 0; |];
      [| 1; 1; |];
      [| 2; 1; |];
    |]
  and int_of_symbol symbol = Dfa.Symbol.(to_int symbol - to_int '0')
  in
  let dfa =
    { Dfa.n = 3;
      symbols = Set.of_sorted_array_unchecked (module Dfa.Symbol) [| '0'; '1'; |];
      transition = (fun state symbol -> transitions.(state).(int_of_symbol symbol));
      final = Set.singleton (module Dfa.State) 1;
    }
  in
  match Dfa.shortest_accepted_string dfa with
  | Some path -> Stdio.print_endline path
  | None -> Stdio.print_endline "no path"
