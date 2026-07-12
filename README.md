# moonbit-toml

[![CI](https://github.com/santiagoguo/moonbit-toml/actions/workflows/ci.yml/badge.svg)](https://github.com/santiagoguo/moonbit-toml/actions/workflows/ci.yml)
[![License](https://img.shields.io/badge/License-Apache--2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![MoonBit](https://img.shields.io/badge/MoonBit-v0.1.0-orange)](https://www.moonbitlang.com/)

A comprehensive TOML v1.0.0 **Data Engineering Toolkit** written in [MoonBit](https://www.moonbitlang.com/).

一个用 MoonBit 从零编写的 TOML 全功能解析与序列化库，提供配置文件的完整生命周期管理——解析、校验、合并（Merge）、差异（Diff）、查询、多格式转换（JSON/YAML/SQL/CSV/XML/DOT）、统计分析。

- **Repository**: <https://github.com/santiagoguo/moonbit-toml>
- **License**: [Apache-2.0](LICENSE)

---

## 安装 / Installation

### 1. 安装 MoonBit 工具链

```bash
# Linux / macOS
curl -fsSL https://cli.moonbitlang.com/install/unix.sh | bash

# Windows PowerShell
irm https://cli.moonbitlang.cn/install/powershell.ps1 | iex
```

安装完成后重启终端，验证版本：

```bash
moon version
```

### 2. 克隆项目

```bash
git clone https://github.com/santiagoguo/moonbit-toml.git
cd moonbit-toml
```

### 3. 构建与运行

```bash
moon build          # 构建
moon run cmd/main   # 运行演示（合并/差异/转换/统计）
moon test           # 运行测试（70/70 通过）
```

---

## Why This Project? / 项目定位

While `bobzhang/toml` focuses on strict TOML 1.1 spec compliance, **moonbit-toml** focuses on **application engineering**:

与仅关注规范合规性的基础解析器不同，本项目定位为**配置数据工程工具包**：

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

Expected output: **70/70 tests passed** (19 white-box + 51 black-box integration tests).

The CI pipeline also runs:

```bash
moon check --deny-warn   # Type checking with warnings as errors
moon fmt --check         # Formatting verification
moon info                # Documentation generation check
moon test --deny-warn    # Test suite with warnings as errors
```

---

## CI / 持续集成

This project uses [GitHub Actions](https://github.com/santiagoguo/moonbit-toml/actions/workflows/ci.yml) for continuous integration on every push and pull request to `main`.

每次推送和 PR 自动执行以下检查：

```bash
moon check --deny-warn   # 类型检查（警告视为错误）
moon fmt --check         # 格式检查
moon info                # 接口文件生成
moon test --deny-warn    # 测试（70/70，警告视为错误）
```

---

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for the full version history. Latest stable: **v1.2.0**.

---

## License

This project is licensed under the [Apache License 2.0](LICENSE).
