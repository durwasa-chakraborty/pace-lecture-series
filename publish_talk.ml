(* publish_talk.ml — PACE Lecture Series talk publisher
   Usage: ocaml unix.cma publish_talk.ml *)
#directory "+unix";;
#load "unix.cma";;

let template_file = "next_talk.template"
let email_file    = "next_talk_email.txt"
let site_base     = "https://pace.cse.iitm.ac.in/pace-research-huddle"

(* ── month helpers ──────────────────────────────────────────────────── *)

let month_table = [
  ("january",   "Jan", "January",    1);
  ("february",  "Feb", "February",   2);
  ("march",     "Mar", "March",      3);
  ("april",     "Apr", "April",      4);
  ("may",       "May", "May",        5);
  ("june",      "Jun", "June",       6);
  ("july",      "Jul", "July",       7);
  ("august",    "Aug", "August",     8);
  ("september", "Sep", "September",  9);
  ("october",   "Oct", "October",   10);
  ("november",  "Nov", "November",  11);
  ("december",  "Dec", "December",  12);
]

let find_month name =
  let lower = String.lowercase_ascii name in
  match List.find_opt (fun (key, abbr, _, _) ->
    key = lower || String.lowercase_ascii abbr = lower
  ) month_table with
  | Some (_, abbr, full, num) -> (abbr, full, num)
  | None -> failwith ("Unknown month: " ^ name)

(* ── date parsing ───────────────────────────────────────────────────── *)

type date = {
  year       : string;
  month_num  : int;
  month_abbr : string;
  month_full : string;
  day        : int;
  weekday    : string;
}

(* Accepts "Weekday DD Month YYYY" or "DD Month YYYY" *)
let parse_date s =
  let parts = String.split_on_char ' ' (String.trim s)
              |> List.filter (fun p -> p <> "") in
  let (weekday, day_s, month_s, year) =
    match parts with
    | [d; m; y]    -> ("", d, m, y)
    | [w; d; m; y] -> (w,  d, m, y)
    | _ -> failwith ("Cannot parse date (expected 'Weekday DD Month YYYY'): " ^ s)
  in
  let day = int_of_string day_s in
  let (month_abbr, month_full, month_num) = find_month month_s in
  { year; month_num; month_abbr; month_full; day; weekday }

(* ── template parsing ───────────────────────────────────────────────── *)

type talk = {
  date    : date;
  speaker : string;
  title   : string;
  venue   : string;
  time    : string;
  gmeet   : string;
  about   : string option;
  abstract: string;
}

let read_all filename =
  let ic = open_in filename in
  let lines = ref [] in
  (try while true do lines := input_line ic :: !lines done
   with End_of_file -> ());
  close_in ic;
  List.rev !lines

let parse_template () =
  let lines = read_all template_file in

  (* Walk lines collecting key:value pairs; ABSTRACT: starts the body block *)
  let rec walk kvs = function
    | [] -> (kvs, "")
    | line :: rest ->
      let trimmed = String.trim line in
      if trimmed = "" then walk kvs rest
      else
        match String.index_opt trimmed ':' with
        | None -> walk kvs rest
        | Some i ->
          let key = String.trim (String.sub trimmed 0 i)
                    |> String.uppercase_ascii in
          let v   = String.trim (String.sub trimmed (i+1) (String.length trimmed - i - 1)) in
          if key = "ABSTRACT" then
            (* everything remaining (plus any inline text) is the abstract *)
            let body = String.concat "\n" rest |> String.trim in
            let abstract =
              if v = "" then body
              else if body = "" then v
              else v ^ "\n" ^ body
            in
            (kvs, abstract)
          else
            walk ((key, v) :: kvs) rest
  in

  let (kvs, abstract) = walk [] lines in

  let get key =
    match List.assoc_opt key kvs with
    | Some v when String.trim v <> "" -> v
    | Some _ -> failwith ("Field is empty: " ^ key)
    | None   -> failwith ("Missing required field: " ^ key)
  in
  let get_opt key =
    match List.assoc_opt key kvs with
    | Some v when String.trim v <> "" -> Some v
    | _ -> None
  in

  { date     = parse_date (get "DATE");
    speaker  = get "SPEAKER";
    title    = get "TITLE";
    venue    = get "VENUE";
    time     = get "TIME";
    gmeet    = get "GMEET";
    about    = get_opt "ABOUT";
    abstract = (if abstract = "" then failwith "ABSTRACT is empty" else abstract) }

(* ── content generation ─────────────────────────────────────────────── *)

(* Escape backslash and double-quote for TOML basic strings *)
let toml_escape s =
  let buf = Buffer.create (String.length s + 4) in
  String.iter (fun c ->
    (match c with
    | '"'  -> Buffer.add_string buf "\\\""
    | '\\' -> Buffer.add_string buf "\\\\"
    | c    -> Buffer.add_char buf c)
  ) s;
  Buffer.contents buf

(* Current local time formatted for Hugo front matter *)
let now_timestamp () =
  let t = Unix.localtime (Unix.gettimeofday ()) in
  Printf.sprintf "%04d-%02d-%02dT%02d:%02d:%02d+05:30"
    (t.Unix.tm_year + 1900) (t.Unix.tm_mon + 1) t.Unix.tm_mday
    t.Unix.tm_hour t.Unix.tm_min t.Unix.tm_sec

let hugo_content t =
  let d = t.date in
  let front_date   = now_timestamp () in
  let hugo_title   = Printf.sprintf "%s %s %02d :: %s"
                       d.year d.month_abbr d.day (toml_escape t.title) in
  let about_line   = match t.about with
    | Some url -> Printf.sprintf "\n- **About the Presenter:** %s" url
    | None     -> ""
  in
  Printf.sprintf
"+++
date = '%s'
title = \"%s\"
author = \"%s\"
draft = false
slides = ''
recording = ''
+++

#### **Talk**
- **Topic:** %s

- **Description:** %s

- **Time** %s
- **Presenter:** %s%s
- **URL** : %s
"
    front_date hugo_title (toml_escape t.speaker)
    t.title t.abstract t.time t.speaker about_line t.gmeet

let display_date d =
  let base = Printf.sprintf "%s %d, %s" d.month_full d.day d.year in
  if d.weekday = "" then base
  else Printf.sprintf "%s, %s" d.weekday base

let email_content t =
  let d    = t.date in
  let slug = Printf.sprintf "%s-%s-%02d-talk-1" d.year d.month_abbr d.day
             |> String.lowercase_ascii in
  let url  = Printf.sprintf "%s/talks/%s/" site_base slug in
  Printf.sprintf
"Dear All,

You are invited to the PACE Lab Lecture Series by %s on:

Topic: \"%s\"

Date: %s
Venue: %s
Time: %s

Video call link: %s
More Information: %s

-regards
Durwasa
"
    t.speaker t.title (display_date d) t.venue t.time t.gmeet url

(* ── shell helper ───────────────────────────────────────────────────── *)

let run cmd =
  Printf.printf "$ %s\n%!" cmd;
  match Sys.command cmd with
  | 0    -> ()
  | code -> failwith (Printf.sprintf "Command failed (exit %d): %s" code cmd)

(* ── main ───────────────────────────────────────────────────────────── *)

let () =
  let t    = parse_template () in
  let d    = t.date in
  let base = Printf.sprintf "%s-%s-%02d-talk-1" d.year d.month_abbr d.day in
  let path = Printf.sprintf "content/talks/%s.md" base in

  (* Write Hugo markdown *)
  let oc = open_out path in
  output_string oc (hugo_content t);
  close_out oc;
  Printf.printf "Wrote: %s\n%!" path;

  (* Build (sanity check — Amplify also builds on deploy) *)
  run "hugo";

  (* Commit and push *)
  run (Printf.sprintf "git add %s" path);
  run (Printf.sprintf "git commit -m \"INFO :: add talk %s %s - %s\""
         base t.speaker t.title);
  run "git push";

  (* Write email *)
  let oc = open_out email_file in
  output_string oc (email_content t);
  close_out oc;
  Printf.printf "Email written to: %s\n%!" email_file
