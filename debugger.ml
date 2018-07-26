open Core_kernel
open Incr_dom

module type Debuggable = sig
  include App_intf.S_simple

  val serialize_model : Model.t -> string

  val serialize_action : Action.t -> string

  val initial_model : Model.t
end

module Make (M : Debuggable) :
  App_intf.S_simple
  with type Model.t = M.Model.t
   and type Action.t = M.Action.t =
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
    let render_history =
      Node.div []
        [ Node.ul []
            (List.map
               ~f:(fun (action, model) ->
                 Node.text
                   (Printf.sprintf "Action: %s - Current Model: %s"
                      (M.serialize_action action)
                      (M.serialize_model model)) )
               !history) ]
    in
    let%map child = M.view m ~inject >>| Core_kernel.Fn.id in
    Node.body [] [render_history; child]

  let on_startup = M.on_startup

  let on_display = M.on_display
end
