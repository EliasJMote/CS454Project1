open Base

module State = Int
module State_set = Set.M(State) [@@deriving compare]

module Symbol = Char
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
   * Returns the shortest path to an accepting state.
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
