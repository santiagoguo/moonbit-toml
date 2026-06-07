# moonbit-toml 迭代路线图 (2026-06-06 ~ 2026-07-10)

> **竞赛截止**：2026-07-10 申报截止
> **验收时间**：2026-07-11 ~ 07-17
> **当前版本**：v1.1.0（4,949 行，19 个测试）
> **迭代节奏**：每周新增功能，周末统一迭代发布

---

## Sprint 总览

| Sprint | 时间 | 主题 | 新增功能 | 质量/基建 |
|--------|------|------|---------|----------|
| **W23** | Jun 6-14 | 质量基建 + TOML v1.1 预览 | 多行引号字符串、Join keys | 黑盒测试、往返测试、CHANGELOG |
| **W24** | Jun 15-21 | CLI 工具 + 模板系统 | 文件级 CLI、变量替换模板 | 性能基准测试 |
| **W25** | Jun 22-28 | Schema DSL + 环境变量 | 声明式验证语言、${ENV} 插值 | 发布 mooncakes.io |
| **W26** | Jun 29-Jul 5 | Patch Apply + 可视化报告 | diff 应用、HTML/Markdown 报告 | 真实 TOML 集成测试 |
| **W27** | Jul 6-12 | 打磨 + 竞赛提交 | 最终修复、文档完善 | 申报材料更新、v2.0 发布 |

---

## Sprint W23 (Jun 6-14): 质量基建 + TOML v1.1 预览

### 新增功能
1. **TOML v1.1.0 多行引号字符串**
   - 支持 `\`...\`` (basic multiline) 和 `''...'''` (literal multiline)
   - 对应 `parse` 模块扩展
2. **TOML v1.1.0 Join Keys**
   - 支持 `a.b.c = 1` 语法（替代嵌套表）
   - 对应 `parse` 模块扩展

### 质量/基建
- 黑盒测试 `lib/toml_test.mbt`（19 → 40+ 测试）
- 往返测试 Round-Trip（parse → serialize → parse）
- CHANGELOG.md + git tag v1.1.0
- 迭代发布：v1.2.0（周末）

---

## Sprint W24 (Jun 15-21): CLI 工具 + 模板系统

### 新增功能
1. **文件级 CLI 工具**
   - `moonbit-toml parse <file>` → JSON 输出
   - `moonbit-toml validate <file>` → 验证报告
   - `moonbit-toml merge <base> <overlay>` → 合并输出
   - `moonbit-toml diff <old> <new>` → 差异输出
   - `moonbit-toml convert <file> --to json|yaml|sql|csv` → 格式转换
2. **TOML 模板系统**
   - 变量替换：`{{ name }}` 语法
   - `render(template, vars)` API
   - 支持条件渲染和循环

### 质量/基建
- 性能基准测试框架（`benches/`）
- CLI 黑盒测试
- 迭代发布：v1.3.0（周末）

---

## Sprint W25 (Jun 22-28): Schema DSL + 环境变量

### 新增功能
1. **TOML Schema DSL**
   - 声明式验证规则语言：
     ```toml
     [schema.server]
     port = { type = "int", min = 1, max = 65535 }
     host = { type = "string", pattern = "^[a-z0-9.]+$" }
     ssl = { type = "bool", required = true }
     ```
   - `validate_with_schema(value, schema)` API
   - 详细错误诊断
2. **环境变量插值**
   - `${ENV_VAR}` 语法解析
   - `interpolate(toml_value, env_map)` API
   - 支持默认值 `${VAR:-default}`

### 质量/基建
- Schema DSL 测试套件
- 发布到 mooncakes.io
- 迭代发布：v1.4.0（周末）

---

## Sprint W26 (Jun 29-Jul 5): Patch Apply + 可视化报告

### 新增功能
1. **TOML Patch Apply**
   - 将 diff 结果应用到 TOML 树：`apply_patch(base, diffs) -> new_value`
   - 支持 git-style patch 文件格式
   - 原子操作（失败回滚）
2. **可视化差异报告**
   - `diff_to_html(diffs) -> String`
   - `diff_to_markdown(diffs) -> String`
   - 支持 colored terminal output

### 质量/基建
- 真实世界 TOML 文件集成测试（从开源项目收集 20+ 配置文件）
- Patch Apply 测试套件
- 迭代发布：v1.5.0（周末）

---

## Sprint W27 (Jul 6-12): 打磨 + 竞赛提交

### 新增功能
1. **TOML 注释保留**
   - parse 时保留原始注释
   - serialize 时还原注释位置
2. **配置迁移工具**
   - `migrate(old_config, new_schema)` API
   - 自动生成迁移脚本

### 质量/基建
- 最终 bug 修复
- 全面文档更新（API doc + user guide）
- 竞赛申报材料最终版
- 迭代发布：v2.0.0（周末，竞赛最终版）

---

## 预期成果

| 指标 | 当前 | W23 | W24 | W25 | W26 | W27 |
|------|------|-----|-----|-----|-----|-----|
| 代码行数 | ~5k | ~6k | ~7k | ~8k | ~9k | ~10k |
| 测试数 | 19 | 40+ | 60+ | 80+ | 100+ | 120+ |
| 版本 | v1.1 | v1.2 | v1.3 | v1.4 | v1.5 | v2.0 |
| mooncakes.io | ❌ | ❌ | ❌ | ✅ | ✅ | ✅ |

---

## 迭代流程（每周末）

1. **周五/周六**：完成本周功能开发
2. **周六**：补充测试 + bug 修复
3. **周日**：
   - `moon test` 全部通过
   - 更新 CHANGELOG.md
   - `git tag v<X.Y.Z>`
   - `git push origin main --tags`
   - 创建 GitHub Release
4. **下周一**：开始下一 Sprint

---

*Created: 2026-06-06*
*Next review: 2026-06-14 (W23 结束)*
