# EuroPi Documentation Site

This repository contains the source code for the **EuroPi documentation website**,
built with **Astro** and **Starlight**.

🔗 **Live website:** https://s0ca.github.io/europi-docs/

---

## Purpose

This repository is **not** the EuroPi firmware itself.

It is a documentation website that:
- consumes Markdown documentation from the upstream EuroPi project
- renders it as a fast, readable static site
- is deployed automatically via GitHub Pages

---

## Development

### Requirements
- Node.js >= 20
- npm

### Run locally
```bash
npm install
npm run dev
```

Then open:
http://localhost:4321/

---

## Build

```bash
npm run build
npm run preview
```

The static output is generated in the `dist/` directory.

---

## Updating documentation content

Documentation files are synchronized from the upstream EuroPi repository.

A helper script is provided to:
- pull upstream changes
- sync Markdown files and assets
- rebuild the site

See:
```
scripts/update.sh
```

---

## Tech stack

- Astro
- Starlight
- GitHub Pages
- GitHub Actions

---
