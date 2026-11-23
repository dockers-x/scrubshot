# scrubshot 镜像仓库

本仓库**不存储上游代码**，只存放自动镜像构建的 Dockerfile 与工作流。上游代码来自 [strugglesky/scrubshot](https://github.com/strugglesky/scrubshot)，每次构建按上游 main 分支的锁定 commit 拉取源码。

## 工作流

- `.github/workflows/image.yml` 每 6 小时比对上游 `main` 的最新 commit sha 与 `upstream.json` 记录的上次构建值。
- 有变化时：锁定该 sha 拉取源码 → `pnpm install --frozen-lockfile && pnpm build` → 构建 `linux/amd64,linux/arm64` 多架构镜像 → 推送 `ghcr.io/dockers-x/scrubshot:<版本>` 与 `:latest` → 把 sha 和版本写回 `upstream.json`。
- 无变化时跳过构建；也可用 `workflow_dispatch` 的 `force` 输入强制构建。
- 构建产物镜像即纯前端静态站点（nginx 托管），版本号由 `upstream.json` 记录的计数递增。
