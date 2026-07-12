# moonbit-toml

[![CI](https://github.com/santiagoguo/moonbit-toml/actions/workflows/ci.yml/badge.svg)](https://github.com/santiagoguo/moonbit-toml/actions/workflows/ci.yml)
[![License](https://img.shields.io/badge/License-Apache--2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![MoonBit](https://img.shields.io/badge/MoonBit-v0.1.0-orange)](https://www.moonbitlang.com/)

A comprehensive TOML v1.0.0 **Data Engineering Toolkit** written in [MoonBit](https://www.moonbitlang.com/).

Unlike standard TOML parsers, this library provides a full lifecycle management solution including **Merge, Diff, Validation, Schema, and Multi-Format Serialization (JSON/YAML/SQL/CSV/XML/DOT)**.

- **Repository**: <https://github.com/santiagoguo/moonbit-toml>
- **License**: [Apache-2.0](LICENSE)

---

## Why This Project?

While `bobzhang/toml` focuses on strict TOML 1.1 spec compliance, **moonbit-toml** focuses on **application engineering**:

- **Configuration Management**: Merge base/overlay configs, diff versions, and audit changes.
- **Interoperability**: Seamlessly convert TOML to JSON, YAML, SQL DDL, CSV, XML, and DOT.
- **Validation**: Built-in schema validation and type linting with 50+ error kinds.
- **Analytics**: Compute tree depth, node counts, and structural statistics.

---

## Features

| Category | Capabilities |
|---|---|
| **Core Parsing** | Full TOML v1.0.0 compliance with recursive descent parser; v1.1.0 backtick strings and dotted keys |
| **Lifecycle API** | `merge()`, `diff()`, `deep_equal()`, `fingerprint()` |
| **Query Engine** | `resolve_path()`, `find_by_wildcard()`, `flatten()`, type-safe getters, `all_paths` |
| **Builder Pattern** | Programmatic TOML construction (`builder_set_*`) |
| **Validation** | Schema validation, datetime validation, homogeneity checks |
| **Multi-Format Export** | `to_json()`, `to_yaml()`, `to_sql_create()`, `to_csv()`, XML, DOT |
| **Statistics** | Tree depth, node counts, structural analysis (`compute_stats`) |
| **Transformations** | `map_leaves`, `prune_empty`, path expressions |
| **Error Reporting** | Comprehensive error system with 50+ distinct error kinds |

---

## Project Structure

```
moonbit-toml/
├── lib/
│   ├── moon.pkg              # Library package declaration
│   ├── toml.mbt              # Core library (~5,500 lines)
│   ├── toml_test.mbt         # Black-box integration tests (50 tests)
│   └── toml_wbtest.mbt       # White-box unit tests (19 tests)
├── cmd/
│   ├── main/
│   │   ├── main.mbt          # CLI showcase (merge/diff/convert demo)
│   │   └── moon.pkg
│   └── cli/
│       ├── cli.mbt           # CLI tool with file operations
│       └── moon.pkg
├── moon.mod                  # Module definition (santiagoguo/moonbit_toml)
├── moon.pkg                  # Root package declaration
├── .github/workflows/
│   └── ci.yml                # GitHub Actions CI pipeline
├── CHANGELOG.md              # Version history (Keep a Changelog format)
└── LICENSE                   # Apache-2.0
```

---

## Usage

### Parsing and Merging Configurations

```moonbit
using @lib { parse, merge, to_json_like }

fn main {
  let base = parse("[server]\nport = 8080")
  let overlay = parse("[server]\nport = 9090\nssl = true")

  let merged = merge(base, overlay)
  println(to_json_like(merged))
}
```

### Diffing Configurations

```moonbit
using @lib { parse, diff }

fn main {
  let v1 = parse("[app]\nversion = \"1.0\"\n")
  let v2 = parse("[app]\nversion = \"2.0\"\ndebug = true\n")

  let changes = diff(v1, v2)
  // Inspect added, removed, and modified keys
}
```

### Multi-Format Export

```moonbit
using @lib { parse, to_json, to_yaml, to_sql_create, to_csv }

fn main {
  let cfg = parse("""
[database]
host = "localhost"
port = 5432
""")

  println(to_json(cfg))
  println(to_yaml(cfg))
  println(to_sql_create(cfg))
}
```

### Programmatic Construction (Builder API)

```moonbit
using @lib { builder_new, builder_set_string, builder_set_int, builder_build }

fn main {
  let b = builder_new()
  builder_set_string(b, ["server", "host"], "0.0.0.0")
  builder_set_int(b, ["server", "port"], 8080)
  let toml = builder_build(b)
}
```

---

## CLI Usage

The project includes demonstration binaries that exercise all advanced features.

### Build and Run the Showcase

```bash
moon build
moon run cmd/main
```

This outputs:
- Configuration merge results (base + overlay)
- Version diffing between config snapshots
- JSON conversion of parsed TOML
- Structural statistics (tree depth, node counts)

### Run the CLI Tool

```bash
moon build
moon run cmd/cli
```

---

## Running Tests

```bash
moon test
```

Expected output: **69/69 tests passed** (19 white-box + 50 black-box integration tests).

The CI pipeline also runs:

```bash
moon check --deny-warn   # Type checking with warnings as errors
moon fmt --check         # Formatting verification
moon info                # Documentation generation check
moon test --deny-warn    # Test suite with warnings as errors
```

---

## CI

This project uses [GitHub Actions](https://github.com/santiagoguo/moonbit-toml/actions/workflows/ci.yml) for continuous integration on every push and pull request to `main`.

---

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for the full version history. Latest stable: **v1.2.0**.

---

## License

This project is licensed under the [Apache License 2.0](LICENSE).
