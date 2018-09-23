open Base

module State = Int
module State_set = Set.M(State) [@@deriving compare]

module Symbol = struct
  include Char
  let to_int c = Char.(to_int c - to_int '0')
  let of_int x = Char.(of_int (x + to_int '0'))
end
module Symbol_set = Set.M(Symbol) [@@deriving compare]

(** The representation of a deterministic finite automaton (DFA).
 *
 * We require a transition function, a set of accepting final states, the
 * number of states (n) and the set of input symbols.
 *)
type t =
  { n: int; (* number of states *)
    symbols: Symbol_set.t; (* set of symbols *)
    transition : State.t -> Symbol.t -> State.t;
    final : State_set.t;
  }

(** Find the shortest input string accepted by a given DFA.
 *
 * Implements the "MinString" function.
 *
 * Returns an option of the lexicographically-first accepted string.
 *)
let shortest_accepted_string { n; symbols; transition; final } =

  (* Mutable state *)
  let queue = Queue.create ()
  and parents = Array.create ~len:n (-1)
  and labels = Array.create ~len:n '\x00'
  and visited = Array.create ~len:n false
  in

  (* Breadth-first search of the state/transition graph.
   *
   * Returns an option of the shortest path to an accepting state.
   *)
  let rec bfs current =
    if Set.mem final current then
      let rec backtrack path = function
        | 0 -> path
        | state -> backtrack (labels.(state) :: path) parents.(state)
      in
      Some (backtrack [] current)
    else
      let update k =
        let next = transition current k
        in
        if not visited.(next) then
          begin
            labels.(next) <- k;
            parents.(next) <- current;
            Queue.enqueue queue next;
          end
      in
      visited.(current) <- true;
      Set.iter ~f:update symbols;
      Option.((Queue.dequeue queue) >>= bfs)
  in

  Option.(bfs 0 >>| String.of_char_list)

(** Create a DFA for decimal strings that are a multiple of a given integer x.
 *
 * The starting state (0) rejects the empty string.
 * The remaining x states represent the running remainder + 1.
 * That means 1 is the accepting state, representing a remainder of 0.
 *)
let accept_decimal_multiples_of x =
  let symbols = Set.of_sorted_array_unchecked (module Symbol) (String.to_array "0123456789")
  in
  let transition state symbol =
    let previous_remainder = max 0 (state - 1)
    and current_digit = Symbol.to_int symbol
    in
    let remainder = (previous_remainder * 10 + current_digit) % x
    in
    remainder + 1
  in
  { n = x + 1; symbols; transition; final = Set.singleton (module State) 1; }

(** Determine the smallest multiple of a given k using only the given digits.
 *
 * Implements the "smallestMultiple" function.
 *
 * Returns an option of the number as a string of decimal digits.
 *)
let smallest_multiple k digits =
  shortest_accepted_string { (accept_decimal_multiples_of k) with symbols = digits }
