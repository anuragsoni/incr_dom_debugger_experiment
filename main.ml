open! Core_kernel
open! Incr_dom
open! Js_of_ocaml

let () =
  let module Wrapped = Debugger.Make (Webby) in
  Start_app.simple
    (module Wrapped)
    ~initial_model:
      (Webby.initial_model)
