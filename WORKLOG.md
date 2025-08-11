# WORKLOG

## 11/8/2025

- rails new
- edit .gitignore
- add SSL for localhost:3000 - dev, debug scripts
- add tenant
- add multi-tenancy landing pages, for sub- and custom domains (alco.psychos.com/alco.com)
- adding dynamic layouts to tenants, and domains
- add seeding first tenant and first theme (psychOS + App Default), idempotent via db/seeds.rb
- Domain form: filter Theme dropdown by selected Tenant (Stimulus controller: themes-filter)
- Theme form: live preview + basic validation for {{yield}} (Stimulus controller: theme-preview)
- Tailwind fix: include tailwind.css in dynamic layout so utilities load on all hosts
- Fallback for unknown hosts: route constraints + landing page; added integration tests to prevent redirect loops
- Blog: model with comments_setting enum, migration, association on Tenant
- Seeds: psychOS default blog
- Blogs: CRUD UI (controller, views) and tests (controller, system)
- Tenant blog landing: tenant-aware /blog and /blog/:id routes; Tenants::BlogsController (default/show); views; link from tenant homepage; integration tests; global fallbacks for non-tenant hosts
- Posts: scaffolded Post (belongs_to Blog) with title, ActionText rich content, published_at; installed ActionText/ActiveStorage tables; controller/views updated; fixtures; controller + system tests passing
- Tenant blog list: render latest 5 posts under each blog description on /blog, ordered by published_at desc (fallback created_at); integration tests for 0, 4, and 6 posts; controller adjusted to always render index
- add Tailwind classes build separate to each tenant
- Dockerfile: install Node.js + npm and pin Tailwind CLI globally (npm i -g @tailwindcss/cli@4) in the base image; final image is FROM base so Node/CLI are available at runtime for TailwindBuildJob in web/worker
- Image verification: docker run --rm psycho node -v; docker run --rm psycho npm -v; docker run --rm psycho tailwindcss --help; docker run --rm psycho npx -y @tailwindcss/cli@4 --help
- prepare domains staging-pry.ztin.gs and psy.ztin.gs for deployment of staging and production
- prepare new repo on GitHub
- 