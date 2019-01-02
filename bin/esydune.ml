type esyenv = {
  name : string;
  dev : bool;
  root : string;
  prefix : string;
}

let error msg =
  let msg = Printf.sprintf "error: esydune: %s" msg in
  prerr_endline msg;
  exit 1

let requireEnv name =
  match Sys.getenv_opt name with
  | None -> error ("cannot find $" ^ name ^ " in environment")
  | Some v -> v

let parseEsyEnv () =
  let root = requireEnv "cur__root" in
  let prefix = requireEnv "cur__install" in
  let dev =
    match requireEnv "cur__dev" with
    | "true" -> true
    | "false" -> false
    | v -> error ("invalid $cur__dev value: " ^ v)
  in
  let name =
    let name = requireEnv "cur__name" in
    if String.length name < 0
    then error "empty $cur__name value"
    else
      if String.get name 0 = '@'
      then
        match String.split_on_char '/' name with
        | _scope::name -> String.concat "/" name
        | _ -> error ("invalid $cur__name value: " ^ name)
      else name
  in
  {name; dev; root; prefix;}

let () =
  let {name; dev; root; prefix} = parseEsyEnv () in
  let args = Array.to_list Sys.argv in
  let duneargs =
    match args with
    | _::"install"::args ->
      let scopeargs = [
        name;
        "--prefix"; prefix;
        "--root"; root;
      ] in
      "install"::(scopeargs @ args)
    | _::cmd::args ->
      let scopeargs =
        if dev
        then [
          "--only-packages"; name;
          "--root"; root;
        ]
        else [
          "--only-packages"; name;
          "--root"; root;
          "--profile"; "release";
          "--default-target"; "@install";
        ]
      in
      cmd::(scopeargs @ args)
    | _ ->
      error "error: esydune: provide subcommand"
  in
  let line = "dune"::duneargs in
  let () =
    let line = List.map Filename.quote line in
    prerr_endline (String.concat " " line)
  in
  Unix.execvp "dune" (Array.of_list line)
