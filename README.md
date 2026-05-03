# YW Blog

A personal technical blog built with Jekyll, covering software engineering, machine learning, and data engineering.

**Live site:** http://neverset123.github.io/YWHome

---

## Content

~191 articles published from 2020–2023, organized by date under `_posts/`. Main topics:

- **Machine Learning & Deep Learning** — TensorFlow, CNNs, transformers, NLP, computer vision, reinforcement learning
- **Data Engineering** — Spark, Kafka, Hadoop, Hive, Elasticsearch, ClickHouse, Airflow
- **Python** — Pandas, NumPy, decorators, testing, CLI, data visualization
- **Infrastructure & DevOps** — Docker, Kubernetes, CI/CD, AWS, Azure, CUDA
- **Web Development** — React, JavaScript, TypeScript, web scraping

---

## Local Development

**Prerequisites:** Ruby, Bundler, Node.js

```bash
# Install dependencies
bundle install
npm install

# Serve locally (http://localhost:4000)
jekyll serve

# Or with Grunt (compiles LESS, minifies assets)
grunt
```

---

## Writing a Post

Create a file in `_posts/` with the naming format `YYYY-MM-DD-title.md`:

```yaml
---
layout:     post
title:      "Post Title"
subtitle:   "Optional subtitle"
date:       YYYY-MM-DD
author:     "YW"
header-img: "img/post-bg-rwd.jpg"
tags:
    - tag1
    - tag2
---

Content here...
```

---

## Project Structure

```
YWHome/
├── _posts/         # Blog articles (Markdown)
├── _layouts/       # Jekyll page templates
├── _includes/      # Reusable HTML fragments (nav, head, footer)
├── css/            # Bootstrap + custom theme stylesheets
├── less/           # LESS source files for CSS
├── js/             # Bootstrap, jQuery, custom scripts
├── fonts/          # Bootstrap Glyphicons
├── img/            # Images and post backgrounds
├── pwa/            # Progressive Web App manifest and icons
├── _config.yml     # Jekyll site configuration
├── index.html      # Homepage
├── about.html      # About page
├── tags.html       # Tags index page
└── feed.xml        # RSS feed
```

---

## Configuration

Key settings in `_config.yml`:

| Field | Description |
|-------|-------------|
| `title` | Site title |
| `SEOTitle` | SEO-optimized title |
| `description` | Site description |
| `url` | Base URL |
| `disqus_username` | Disqus comment system ID |
| `gitalk.*` | GitHub-based comment system config |
| `ga_track_id` | Google Analytics tracking ID |
| `featured-tags` | Enable tag cloud on sidebar |

---

## Tech Stack

- **[Jekyll](https://jekyllrb.com/)** — static site generator
- **[Bootstrap 3](https://getbootstrap.com/docs/3.4/)** — responsive layout
- **[jQuery](https://jquery.com/)** — interactivity
- **[Grunt](https://gruntjs.com/)** — LESS compilation and asset minification
- **[Gitalk](https://github.com/gitalk/gitalk)** — GitHub-based comments
- **PWA** — service worker + web app manifest

---

## License

MIT
