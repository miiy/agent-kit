# agent-kit

`[English](README.md) | 简体中文`

通用工程规范工具包：一份 `AGENTS.md`，克隆进项目里使用，Codex / Claude Code / DeepSeek Harness 都能读。

## 功能

- 规则只有一份 `AGENTS.md`，全部写成短句条目。
- `install.sh` 把本仓库克隆到项目的 `.agent-kit`，并软链 `AGENTS.md`，三个工具自动加载。
- 项目特有规则写 `PROJECT.md`，仅本机使用的补充写 `AGENTS.local.md`，互不污染。

## 快速开始

```bash
git clone <this-repo> agent-kit && cd agent-kit

make install DIR=/path/to/project              # 克隆进项目的 .agent-kit
make install DIR=/path/to/project URL=git@github.com:<you>/agent-kit.git
make install DIR=/path/to/project LANG=zh-CN   # 中文规则（默认英文）
make install-dry DIR=/path/to/project          # 只预览
make install-local DIR=/path/to/project        # 软链本机 checkout，不克隆
```

安装后项目里多出：

```
<project>/
├── .agent-kit/     （不入库）
├── AGENTS.md       （软链）
├── PROJECT.md
└── .gitignore
```

然后提交：

```bash
git add AGENTS.md PROJECT.md .gitignore
git commit -m "feat: add agent-kit rules"
```

## 更新规则

```bash
make pull DIR=/path/to/project     # 等价于 git -C <project>/.agent-kit pull
```

## 规则语言

安装时按语言选软链目标，项目里的文件名始终是 `AGENTS.md`：

- `--lang en` → 软链到 `.agent-kit/AGENTS.md`（英文，默认）
- `--lang zh-CN` → 软链到 `.agent-kit/AGENTS.zh-CN.md`（中文）
- 不传时读环境变量 `LC_ALL`/`LANG`：`zh*` 选中文，否则英文

两份内容必须同步更新。

## 目录结构

```
AGENTS.md                     规则源（英文，默认）
AGENTS.zh-CN.md               规则源（简体中文）
install.sh                    安装到一个项目（克隆 + 软链 + PROJECT.md + .gitignore）
templates/PROJECT.md          项目特有规则模板
templates/PLAN.md             大改动的计划模板
README.md / README.zh-CN.md / LICENSE / CHANGELOG.md / Makefile
```

## 贡献

1. 通用规则改 `AGENTS.md`，两份语言同步改；项目特有的写该项目的 `PROJECT.md`，不进这里。
2. 一条一个 `- `：写清做什么以及边界，不写理由、不写历史。
3. 一次 PR 只做一类改动，标题用 Conventional Commits，例如 `docs(rules): 分支规则改为引用 conventional-branch`。
4. 分支用 `chore/<描述>` 或 `docs/<描述>`；改动影响安装行为的，同步更新 `README` 与 `CHANGELOG`。

**注意**：项目里的 `AGENTS.md` 是软链，编辑它会改到 `.agent-kit` 里的规则源。项目内容一律写 `PROJECT.md`。

## 许可证

MIT，见 [LICENSE](LICENSE)。
