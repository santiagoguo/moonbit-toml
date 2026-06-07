# Changelog

All notable changes to moonbit-toml will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- CLI tool with file operations
- Template system with variable substitution
- Schema DSL for declarative validation
- Environment variable interpolation

## [1.2.0] - 2026-06-06

### Added
- TOML v1.1.0 backtick string literals (`...`)
- TOML v1.1.0 triple backtick multiline strings (```...```)
- TOML v1.1.0 dotted/join keys (a.b.c = value syntax)
- 50 new black-box integration tests (lib/toml_test.mbt)
- Round-trip tests for all data types

### Changed
- Total tests: 19 → 69 (100% pass)
- Lexer now supports 6 string token types (was 4)

### Known Limitations
- Serialize round-trip for arrays needs fix (tracked in issue)
- Merge module has edge case panics with table merging

## [1.1.0] - 2026-05-27

### Added
- Event-Driven Parser Simulation (State Machine)
- TOML to SQL Mapper
- Configuration Profile Manager
- YAML Block Style Serialization
- Comprehensive Error Reporting (50+ error kinds)

## [1.0.0] - 2026-05-27

### Added
- Advanced Utilities
- Type Conversion and Coercion
- Tree Manipulation
- Debug and Inspection tools

## [0.9.0] - 2026-05-27

### Added
- Advanced Query and Filtering
- Schema Validation
- Extended Serialization (XML, CSV)

## [0.8.0] - 2026-05-27

### Added
- Path Expressions Module
- Transformation Module (map_leaves, prune_empty)
- Visualization and Extended Serialization

## [0.7.0] - 2026-05-27

### Added
- Statistics Module (compute_stats)
- Pretty Print and Serialization Options
- Flatten Module

## [0.6.0] - 2026-05-27

### Added
- Merge Module (deep merge for base/overlay configs)
- Diff Module (fine-grained change auditing)
- Deep equality comparison (deep_equal)

## [0.5.0] - 2026-05-27

### Added
- Validation Module (validate, validate_datetimes, is_homogeneous)

## [0.4.0] - 2026-05-27

### Added
- Builder API for programmatic TOML construction

## [0.3.0] - 2026-05-27

### Added
- Comprehensive Query API (get_key, get_nested, type-safe getters, all_paths)

## [0.2.0] - 2026-05-26

### Added
- ensure_table_path for proper nested table creation

## [0.1.0] - 2026-05-26

### Added
- Complete TOML v1.0.0 parser/serializer
- Recursive descent parser
- Full serializer with round-trip support
- Error system with detailed reporting
- Date-time parsing (OffsetDateTime, LocalDateTime, LocalDate, LocalTime)
- White-box tests (7 passed)

[Unreleased]: https://github.com/santiagoguo/moonbit-toml/compare/v1.1.0...HEAD
[1.1.0]: https://github.com/santiagoguo/moonbit-toml/compare/v1.0...v1.1.0
[1.0.0]: https://github.com/santiagoguo/moonbit-toml/compare/v0.9...v1.0
[0.9.0]: https://github.com/santiagoguo/moonbit-toml/compare/v0.8...v0.9
[0.8.0]: https://github.com/santiagoguo/moonbit-toml/compare/v0.7...v0.8
[0.7.0]: https://github.com/santiagoguo/moonbit-toml/compare/v0.6...v0.7
[0.6.0]: https://github.com/santiagoguo/moonbit-toml/compare/v0.5...v0.6
[0.5.0]: https://github.com/santiagoguo/moonbit-toml/compare/v0.4...v0.5
[0.4.0]: https://github.com/santiagoguo/moonbit-toml/compare/v0.3...v0.4
[0.3.0]: https://github.com/santiagoguo/moonbit-toml/compare/v0.2...v0.3
[0.2.0]: https://github.com/santiagoguo/moonbit-toml/compare/v0.1...v0.2
[0.1.0]: https://github.com/santiagoguo/moonbit-toml/releases/tag/v0.1
