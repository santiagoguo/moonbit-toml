// cmd/cli/cli.mbt
// MoonBit TOML CLI Tool
// Usage: moon run cmd/cli [command] [args]
//
// Commands:
//   parse <toml_string>     - Parse TOML and output JSON-like
//   validate <toml_string>  - Validate TOML syntax
//   merge <base> <overlay>  - Merge two TOML strings
//   diff <old> <new>        - Show differences
//   template <template> <vars> - Render template with variables

using @lib { 
  parse, serialize_pretty, merge, diff, to_json_like,
  validate, try_parse, is_valid_toml, render_template
}
using @env { args, get_env_var }

// ============================================================
// CLI Commands
// ============================================================

fn cmd_parse(toml_str : String) -> Unit {
  match parse(toml_str) {
    Some(v) => {
      println(to_json_like(v))
    }
    None => {
      println("Error: Failed to parse TOML")
    }
  }
}

fn cmd_validate(toml_str : String) -> Unit {
  match parse(toml_str) {
    Some(v) => {
      let result = validate(v)
      if result.valid {
        println("Valid TOML")
      } else {
        let mut i = 0
        while i < result.errors.length() {
          let msg = result.errors[i]
          println("Error: " + msg)
          i = i + 1
        }
      }
    }
    None => {
      println("Error: Failed to parse TOML")
    }
  }
}

fn cmd_merge(base_str : String, overlay_str : String) -> Unit {
  match (parse(base_str), parse(overlay_str)) {
    (Some(base), Some(overlay)) => {
      let merged = merge(base, overlay)
      println(serialize_pretty(merged))
    }
    _ => {
      println("Error: Failed to parse one or both inputs")
    }
  }
}

fn cmd_diff(old_str : String, new_str : String) -> Unit {
  match (parse(old_str), parse(new_str)) {
    (Some(old_v), Some(new_v)) => {
      let diffs = diff(old_v, new_v)
      if diffs.length() == 0 {
        println("No differences found.")
      } else {
        let mut i = 0
        while i < diffs.length() {
          let entry = diffs[i]
          println("- " + entry.to_string())
          i = i + 1
        }
      }
    }
    _ => {
      println("Error: Failed to parse one or both inputs")
    }
  }
}

fn cmd_template(template_str : String, vars_json : String) -> Unit {
  // Simple key=value pairs separated by commas
  let vars : Map[String, String] = Map([])
  let tmp = vars_json.split(",")
  let arr = tmp.to_array()
  let mut idx = 0
  while idx < arr.length() {
    let pair = arr[idx]
    let trimmed = pair.trim().to_string()
    match trimmed.split_once("=") {
      Some((key, value)) => {
        vars.set(key.trim().to_string(), value.trim().to_string())
      }
      None => { let _ = 0 }
    }
    idx = idx + 1
  }
  let rendered = render_template(template_str, vars)
  println(rendered)
}

fn print_usage() -> Unit {
  println("MoonBit TOML Toolkit CLI")
  println("")
  println("Usage: moon run cmd/cli <command> [args...]")
  println("")
  println("Commands:")
  println("  parse <toml>            Parse TOML and output JSON-like")
  println("  validate <toml>         Validate TOML syntax")
  println("  merge <base> <overlay>  Merge two TOML strings")
  println("  diff <old> <new>        Show differences between TOML")
  println("  template <tpl> <vars>   Render template with variables")
  println("  help                    Show this help")
}

fn main {
  let argv = args()
  if argv.length() < 2 {
    print_usage()
    return
  }
  
  let command = argv[1]
  match command {
    "parse" => {
      if argv.length() < 3 {
        println("Usage: moon run cmd/cli parse '<toml_string>'")
        return
      }
      cmd_parse(argv[2])
    }
    "validate" => {
      if argv.length() < 3 {
        println("Usage: moon run cmd/cli validate '<toml_string>'")
        return
      }
      cmd_validate(argv[2])
    }
    "merge" => {
      if argv.length() < 4 {
        println("Usage: moon run cmd/cli merge '<base>' '<overlay>'")
        return
      }
      cmd_merge(argv[2], argv[3])
    }
    "diff" => {
      if argv.length() < 4 {
        println("Usage: moon run cmd/cli diff '<old>' '<new>'")
        return
      }
      cmd_diff(argv[2], argv[3])
    }
    "template" => {
      if argv.length() < 4 {
        println("Usage: moon run cmd/cli template '<tpl>' 'key1=val1,key2=val2'")
        return
      }
      cmd_template(argv[2], argv[3])
    }
    "help" | "--help" | "-h" => {
      print_usage()
    }
    _ => {
      println("Unknown command: " + command)
      print_usage()
    }
  }
}
