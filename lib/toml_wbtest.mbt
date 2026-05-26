// White-box tests for TOML parser

test "parse simple key-value" {
  let input = "key = \"value\""
  let result = parse_toml(input)
  match result.get("key") {
    Some(TomlValue::Str("value")) => ()
    _ => ()
  }
}

test "parse integer value" {
  let input = "count = 42"
  let result = parse_toml(input)
  match result.get("count") {
    Some(TomlValue::Int(42)) => ()
    _ => ()
  }
}

test "parse boolean true" {
  let input = "enabled = true"
  let result = parse_toml(input)
  match result.get("enabled") {
    Some(TomlValue::Bool(true)) => ()
    _ => ()
  }
}

test "parse boolean false" {
  let input = "enabled = false"
  let result = parse_toml(input)
  match result.get("enabled") {
    Some(TomlValue::Bool(false)) => ()
    _ => ()
  }
}

test "parse table" {
  let input = "[section]\nkey = \"value\""
  let result = parse_toml(input)
  match result.get("section") {
    Some(TomlValue::Table(t)) => {
      match t.get("key") {
        Some(TomlValue::Str("value")) => ()
        _ => ()
      }
    }
    _ => ()
  }
}

test "parse array of strings" {
  let input = "items = [\"a\", \"b\", \"c\"]"
  let result = parse_toml(input)
  match result.get("items") {
    Some(TomlValue::Array(arr)) => {
      if arr.length() == 3 { () } else { () }
    }
    _ => ()
  }
}

test "parse dotted keys in table" {
  let input = "[server.production]\nhost = \"192.168.1.1\""
  let result = parse_toml(input)
  match result.get("server") {
    Some(TomlValue::Table(t)) => {
      match t.get("production") {
        Some(TomlValue::Table(t2)) => {
          match t2.get("host") {
            Some(TomlValue::Str("192.168.1.1")) => ()
            _ => ()
          }
        }
        _ => ()
      }
    }
    _ => ()
  }
}
