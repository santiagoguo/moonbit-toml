///|
using @lib {parse, serialize_pretty, merge, diff, compute_stats, to_json_like}

///|
fn main {
  println("==========================================================")
  println("  MoonBit TOML Toolkit - Advanced Features Showcase")
  println("==========================================================\n")

  println("1. Configuration Merge (Base + Overlay)")
  println("----------------------------------------------------------")
  demo_merge()

  println("\n2. Configuration Diff (Version Comparison)")
  println("----------------------------------------------------------")
  demo_diff()

  println("\n3. Multi-Format Conversion (TOML -> JSON)")
  println("----------------------------------------------------------")
  demo_convert()

  println("\n4. Structure Statistics")
  println("----------------------------------------------------------")
  demo_stats()

  println("\n==========================================================")
  println("  Showcase Complete.")
  println("==========================================================")
}

///|
fn demo_merge() -> Unit {
  let base_str = "[server]\nhost = \"192.168.1.1\"\nport = 8080\ntimeout = 30\n\n[database]\ndriver = \"mysql\""
  let overlay_str = "[server]\nport = 9090\ndebug = true\n\n[database]\ndriver = \"mysql\"\nuser = \"admin\""

  let base_parsed = match parse(base_str) {
    Some(v) => v
    None => {
      println("Base parse failed")
      return
    }
  }

  let overlay_parsed = match parse(overlay_str) {
    Some(v) => v
    None => {
      println("Overlay parse failed")
      return
    }
  }

  let merged = merge(base_parsed, overlay_parsed)
  println(serialize_pretty(merged))
}

///|
fn demo_diff() -> Unit {
  let v1_str = "[app]\nversion = \"1.0.0\"\nport = 80"
  let v2_str = "[app]\nversion = \"2.0.0\"\nport = 80\nssl = true"

  let parsed_v1 = match parse(v1_str) {
    Some(v) => v
    None => {
      println("V1 parse failed")
      return
    }
  }

  let parsed_v2 = match parse(v2_str) {
    Some(v) => v
    None => {
      println("V2 parse failed")
      return
    }
  }

  let diffs = diff(parsed_v1, parsed_v2)

  if diffs.length() == 0 {
    println("No differences found.")
  } else {
    println("Changes detected:")
    let mut i = 0
    while i < diffs.length() {
      let entry = diffs[i]
      // DiffEntry implements Show
      println("- " + entry.to_string())
      i = i + 1
    }
  }
}

///|
fn demo_convert() -> Unit {
  let toml_str = "[database]\nhost = \"10.0.0.1\"\nport = 5432\n\n[logging]\nlevel = \"info\""

  let parsed = match parse(toml_str) {
    Some(v) => v
    None => {
      println("Parse failed")
      return
    }
  }

  println("Original TOML:")
  println(toml_str)

  println("\nConverted JSON:")
  println(to_json_like(parsed))
}

///|
fn demo_stats() -> Unit {
  let input_str = "[server]\nhost = \"localhost\"\nport = 8080\n\n[users]\ncount = 100\nroles = [\"admin\", \"user\"]"

  match parse(input_str) {
    Some(v) => {
      let stats = compute_stats(v)
      println("Total Keys: " + stats.total_keys.to_string())
      println("Max Depth: " + stats.max_depth.to_string())
      println("Total Strings: " + stats.total_strings.to_string())
    }
    None => println("Parse failed")
  }
}
