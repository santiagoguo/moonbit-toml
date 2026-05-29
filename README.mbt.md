# moonbit-toml

A comprehensive TOML v1.0.0 **Data Engineering Toolkit** written in MoonBit.
Unlike standard parsers, this library provides a full lifecycle management solution including **Merge, Diff, Validation, Schema, and Multi-Format Serialization (JSON/YAML/SQL/CSV/XML)**.

## 🌟 Why this project?
While `bobzhang/toml` focuses on strict TOML 1.1 spec compliance, **moonbit-toml** focuses on **application engineering**:
- 🛠️ **Configuration Management**: Merge base/overlay configs, diff versions.
- 🔄 **Interoperability**: Seamlessly convert TOML to JSON, YAML, SQL DDL, CSV, and DOT.
- 🛡️ **Validation**: Built-in Schema validation and Type Linting.
- 📊 **Analytics**: Compute tree depth, node counts, and structural statistics.

## Features

- ✅ **Core Parsing**: Full TOML v1.0.0 compliance with recursive descent parser
- ✅ **Lifecycle API**: `merge()`, `diff()`, `deep_equal()`, `fingerprint()`
- ✅ **Query Engine**: `resolve_path()`, `find_by_wildcard()`, `flatten()`
- ✅ **Builder Pattern**: Programmatic TOML construction (`builder_set_*`)
- ✅ **Multi-Format Export**: `to_json()`, `to_yaml()`, `to_sql_create()`, `to_csv()`
- ✅ **CLI Showcase**: Built-in demonstration of all advanced features

## Project Structure

```
moonbit-toml/
├── lib/
│   ├── toml.mbt          # Core Library (~5,500 lines)
│   └── toml_wbtest.mbt   # 19/19 White-box tests (100% Pass)
└── cmd/
    └── main/
        └── main.mbt      # CLI Showcase (Merge/Diff/Convert)
```

## Usage

```moonbit
using @lib { parse, merge, diff, to_json_like }

fn main {
  let base = parse("[server]\nport = 8080")
  let overlay = parse("[server]\nport = 9090\nssl = true")
  
  let merged = merge(base, overlay)
  println(to_json_like(merged))
}
```

## CLI Showcase
Run the built-in demonstration to see advanced features in action:
```bash
moon build
moon run cmd/main
```
*Outputs: Configuration Merge, Version Diffing, JSON Conversion, and Structure Statistics.*

## Running Tests
```bash
moon test
# 19/19 tests passed
```

## License
Apache-2.0
