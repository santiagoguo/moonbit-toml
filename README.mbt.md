# moonbit-toml

A high-performance TOML parser and serializer library written in MoonBit.

## Features

- ✅ Basic key-value parsing (Strings, Integers, Floats, Booleans)
- ✅ Table support (`[section]`)
- ✅ Nested tables (`[server.production]`)
- ✅ Arrays of values (`[1, 2, "mixed"]`)
- ✅ Comment handling (`# comments`)
- ✅ String escaping (`\n`, `\t`, `\"`, `\\`)
- ✅ Dotted key support

## Project Structure

```
moonbit-toml/
├── moon.mod              # MoonBit module definition
├── lib/
│   ├── moon.pkg          # Library package config
│   ├── toml.mbt          # Core TOML parser implementation
│   └── toml_wbtest.mbt   # White-box unit tests
└── cmd/
    └── main/
        ├── moon.pkg      # Main package config
        └── main.mbt      # CLI entry point
```

## Usage

```moonbit
using @lib { parse_toml }

fn main {
  let input = """
  title = "TOML Example"
  [server]
  host = "192.168.1.1"
  port = 8080
  """
  let result = parse_toml(input)
  println(result.to_string())
}
```

## Running Tests

```bash
moon test
```

## Building

```bash
moon build
moon run cmd/main
```

## Roadmap

- [ ] Array of Tables (`[[products]]`)
- [ ] Date/Time parsing
- [ ] Multiline strings (`"""..."""`)
- [ ] TOML serialization (value to string)
- [ ] Full error reporting with line/column numbers
- [ ] Benchmark suite

## License

Apache-2.0

## Competition

This project is submitted to the **MoonBit Open Source Competition 2026**.
