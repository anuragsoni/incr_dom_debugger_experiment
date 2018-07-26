open Incr_dom

module Make (M : App_intf.S_simple) :
  App_intf.S_simple
  with type Model.t = M.Model.t
   and type Action.t = M.Action.t =
struct
  module Model = M.Model

  module Action = M.Action
  module State = M.State

  let apply_action = M.apply_action

  let update_visibility = M.update_visibility

  let view = M.view

  let on_startup = M.on_startup

  let on_display = M.on_display
end
