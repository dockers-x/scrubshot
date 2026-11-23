# syntax=docker/dockerfile:1
# Scrubshot 纯前端静态站：Node 22 + pnpm 11 构建，nginx 托管。
# 构建上下文根目录需包含 checkout 出来的上游源码（upstream/）。
FROM node:22-alpine AS build

# pnpm 版本与上游 CI 一致（pnpm/action-setup@v4: version 11）
RUN corepack enable && corepack prepare pnpm@11 --activate

WORKDIR /src
COPY upstream/ ./

# .npmrc（@sanduc scope 走官方源）与 pnpm-workspace.yaml（allowBuilds）都随上游源码带入
RUN pnpm install --frozen-lockfile \
    && pnpm build

FROM nginx:1.29-alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /src/dist /usr/share/nginx/html

EXPOSE 80
