open Incr_dom

module type Debuggable = sig
  include App_intf.S_simple
end

module Make (M : App_intf.S_simple) :
  Debuggable with type Model.t = M.Model.t and type Action.t = M.Action.t =
struct
  module Model = M.Model
  module Action = M.Action
  module State = M.State

  let history : (Action.t * Model.t) list ref = ref []

  let push_to_history action model = history := (action, model) :: !history

  let apply_action action model state =
    let updated_model = M.apply_action action model state in
    push_to_history action updated_model ;
    updated_model

  let update_visibility = M.update_visibility

  let view (m: Model.t Incr.t) ~inject =
    let open Incr.Let_syntax in
    let open Vdom in
    let dummy = Node.div [] [Node.text "Hello"] in
    let%map child = M.view m ~inject >>| Core_kernel.Fn.id in
    Node.body [] [dummy; child]

  let on_startup = M.on_startup

  let on_display = M.on_display
end
