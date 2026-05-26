using @lib {
  parse_toml
}

fn main {
  let input = "title = \"TOML Example\"\nname = \"Tom\"\nversion = 123"
  let result = parse_toml(input)
  println("Parsed: \{result.to_string()}")
}
