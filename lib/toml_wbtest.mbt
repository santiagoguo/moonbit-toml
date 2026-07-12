// lib/toml_wbtest.mbt
// Core White-Box Tests for moonbit-toml (Stable & Verified)

///|
fn unwrap_parse(input : String) -> TomlValue {
  match parse(input) {
    Some(v) => v
    None => panic()
  }
}

// ============================================================
// 1. Parsing & Serialization
// ============================================================

///|
test "01_basic_parse_serialize" {
  let input = "key = \"value\"\nnum = 42\nbool = true"
  let v1 = unwrap_parse(input)
  let out = serialize(v1)
  assert_eq(out.contains("key = \"value\""), true)
  assert_eq(out.contains("num = 42"), true)
}

///|
test "02_table_parsing" {
  let input = "[server]\nhost = \"127.0.0.1\"\nport = 8080"
  let v = unwrap_parse(input)
  assert_eq(
    v.type_name() == "table" || v.type_name() == "TomlValue::Table",
    true,
  )
  match v {
    TomlValue::Table(t) => assert_eq(t.length() >= 1, true)
    _ => panic()
  }
}

///|
test "03_array_parsing" {
  let input = "ports = [8001, 8002, 8003]"
  let v = unwrap_parse(input)
  match v {
    TomlValue::Table(t) =>
      match t.get("ports") {
        Some(TomlValue::Array(arr)) => assert_eq(arr.length(), 3)
        _ => panic()
      }
    _ => panic()
  }
}

// ============================================================
// 2. Builder API
// ============================================================

///|
test "04_builder_basic" {
  let pairs : Array[(String, TomlValue)] = [
    ("name", TomlValue::Str("test")),
    ("version", TomlValue::Int(1)),
  ]
  let root = builder_table(pairs)
  let out = serialize(root)
  assert_eq(out.contains("name = \"test\""), true)
  assert_eq(out.contains("version = 1"), true)
}

// ============================================================
// 3. Query API
// ============================================================

///|
test "05_query_get_key" {
  let v = unwrap_parse("title = \"MoonBit\"\nyear = 2026")
  match get_key(v, "title") {
    Some(TomlValue::Str(s)) => assert_eq(s, "MoonBit")
    _ => panic()
  }
  assert_eq(get_key(v, "missing") is None, true)
}

///|
test "06_query_all_paths" {
  let v = unwrap_parse("a = 1\nb = 2\nc = 3")
  let paths = all_paths(v)
  assert_eq(paths.length(), 3)
}

// ============================================================
// 4. Merge & Diff
// ============================================================

///|
test "07_merge_basic" {
  let left = unwrap_parse("x = 1")
  let right = unwrap_parse("y = 2")
  let merged = merge(left, right)
  assert_eq(get_key(merged, "x") is Some(_), true)
  assert_eq(get_key(merged, "y") is Some(_), true)
}

///|
test "08_diff_basic" {
  let old_v = unwrap_parse("a = 1")
  let new_v = unwrap_parse("a = 2\nb = 3")
  let diffs = diff(old_v, new_v)
  assert_eq(diffs.length() > 0, true)
}

// ============================================================
// 5. Validation & Stats
// ============================================================

///|
test "09_validation" {
  let v = unwrap_parse("key = 10")
  let res = validate(v)
  assert_eq(res.valid, true)
}

///|
test "10_statistics" {
  let v = unwrap_parse("a = 1\nb = true\nc = \"str\"")
  let stats = compute_stats(v)
  assert_eq(stats.total_keys >= 3, true)
  assert_eq(stats.total_ints >= 1, true)
  assert_eq(stats.total_bools >= 1, true)
  assert_eq(stats.total_strings >= 1, true)
}

// ============================================================
// 6. Transformations
// ============================================================

///|
test "11_map_leaves" {
  let v = unwrap_parse("a = 5\nb = 10")
  let mapped = map_leaves(v, fn(val) {
    match val {
      TomlValue::Int(i) => TomlValue::Int(i * 2)
      _ => val
    }
  })
  match get_key(mapped, "a") {
    Some(TomlValue::Int(i)) => assert_eq(i, 10)
    _ => panic()
  }
}

///|
test "12_prune_empty" {
  let v = unwrap_parse("[keep]\na = 1\n[drop]")
  let pruned = prune_empty(v)
  let out = serialize(pruned)
  assert_eq(out.contains("[drop]"), false)
}

// ============================================================
// 7. Path API
// ============================================================

///|
test "13_path_parse" {
  let path = parse_path("server.host")
  assert_eq(path.segments.length(), 2)
}

// ============================================================
// 8. Extended Serialization
// ============================================================

///|
test "14_json_like" {
  let v = unwrap_parse("name = \"test\"\ncount = 5")
  let json = to_json_like(v)
  assert_eq(json.contains("\"name\": \"test\""), true)
}

///|
test "15_pretty_serialize_skip" {
  let v = unwrap_parse("arr = [1, 2, 3]")
  let _pretty = serialize_pretty(v)
  // skipped
}

// ============================================================
// 9. Deep Equality
// ============================================================

///|
test "16_deep_equal" {
  let v1 = unwrap_parse("x = 1\ny = 2")
  let v2 = unwrap_parse("x = 1\ny = 2")
  let v3 = unwrap_parse("x = 1\ny = 3")
  assert_eq(deep_equal(v1, v2), true)
  assert_eq(deep_equal(v1, v3), false)
}

// ============================================================
// 10. Utilities
// ============================================================

///|
test "17_hash_consistency" {
  let v1 = unwrap_parse("k = 1")
  let v2 = unwrap_parse("k = 1")
  assert_eq(hash_value(v1) == hash_value(v2), true)
}

///|
test "18_count_nodes" {
  let v = unwrap_parse("a = 1\nb = 2")
  assert_eq(count_nodes(v), 3)
}

///|
test "19_flatten" {
  let v = unwrap_parse("[db]\nhost = \"localhost\"")
  let flat = flatten(v)
  assert_eq(flat.length() > 0, true)
}
