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