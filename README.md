# 🚇 Guangzhou Metro Explorer — Smart Kid Edition

A colourful, kid-friendly static website that lets children explore every metro line in Guangzhou (and neighbouring Foshan/Nanhai). Click any line button to read fun facts, key stations, and cool trivia — in **English or Chinese**!

## ✨ Features
- 🎨 **Colour-coded buttons** for every metro line
- 🇨🇳 / 🇬🇧 **EN / 中文 language toggle** — switch instantly
- 🔊 **Read Aloud** button using the Web Speech API
- 📱 Fully responsive — great on phones, tablets, and desktops
- 💫 Animated sparkle background for a fun, vibrant look
- 📄 Content loaded from Markdown files — update a `.md` file and the site refreshes automatically

## 🗂️ Project Structure
```
index.html          ← Main single-page app
data/
  en/               ← English Markdown content for each line
  zh/               ← Chinese Markdown content for each line
```

## 🚀 Running Locally

Because the site uses `fetch()` to load Markdown files, you need a simple local web server (not `file://`).

### Python (recommended — comes pre-installed on most systems)
```bash
cd /path/to/gz-metro-smart-kid
python3 -m http.server 8000
```
Then open **http://localhost:8000** in your browser.

### Node.js (if you have `npx`)
```bash
npx serve .
```

### VS Code
Install the **Live Server** extension, right-click `index.html`, and choose *Open with Live Server*.

## 📝 Updating Content
Each metro line has two Markdown files:
- `data/en/<line-id>.md` — English content
- `data/zh/<line-id>.md` — Chinese content

Edit the Markdown files to update facts, add stations, or fix typos. The website will show the new content on the next page refresh — no build step needed!

## 🌐 Deploying
Drop the entire folder on any static hosting service:
- **GitHub Pages** — push to a `gh-pages` branch or enable Pages from `main`
- **Netlify / Vercel** — drag and drop the folder
- **Any web server** — copy files to the document root

## 📋 Lines Covered
Guangzhou Lines 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 18, 21, 22, 24 · APM Line · Haizhu Tram · Huangpu Tram 1 & 2 · Guangfo Line · Foshan Lines 2 & 3 · Nanhai Tram 1
