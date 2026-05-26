pub use @lib/parser.parse_toml
pub use @lib/value.TomlValue

// Example usage
pub fn main {
  let input = "title = \"TOML Example\"\n[owner]\nname = \"Tom\"\ndob = 1979-05-27"
  let result = parse_toml(input)
  println(result.to_string())
}
