import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";
import { Marked } from "marked";
import markedAlert from "marked-alert";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const outputDir = path.join(__dirname, "_site");

if (!fs.existsSync(outputDir)) {
  fs.mkdirSync(outputDir, { recursive: true });
}

const markedInstance = new Marked(
  markedAlert()
);

markedInstance.setOptions({
  gfm: true,
  breaks: false,
});

function highlightCode(token) {
  const lang = token.lang || "";
  const langClass = lang ? ` class="language-${lang}"` : "";
  const escaped = (token.text || token.raw)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
  return `<pre><code${langClass}>${escaped}</code><button class="copy-btn" aria-label="Copy code" title="Copy to clipboard"><svg viewBox="0 0 24 24" width="16" height="16"><path fill="currentColor" d="M16 1H4c-1.1 0-2 .9-2 2v14h2V3h12V1zm3 4H8c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h11c1.1 0 2-.9 2-2V7c0-1.1-.9-2-2-2zm0 16H8V7h11v14z"/></svg></button></pre>`;
}

const template = `<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ title }}</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/github-dark.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js"></script>
    <style>
        :root {
            --bg-page: #faf9f7;
            --bg-card: #ffffff;
            --bg-code: #f0ede8;
            --text-primary: #3d405b;
            --text-secondary: #6b6d7a;
            --accent: #e07a5f;
            --accent-hover: #d56a4f;
            --border: #e8e5e0;
            --shadow: rgba(61, 64, 91, 0.08);
        }

        @media (prefers-color-scheme: dark) {
            :root {
                --bg-page: #1a1a1a;
                --bg-card: #252525;
                --bg-code: #2d2d2d;
                --text-primary: #f4f1de;
                --text-secondary: #a8a8a8;
                --accent: #e07a5f;
                --accent-hover: #f08a6f;
                --border: #3a3a3a;
                --shadow: rgba(0, 0, 0, 0.3);
            }
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background-color: var(--bg-page);
            color: var(--text-primary);
            line-height: 1.7;
            min-height: 100vh;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 2rem 1.5rem;
        }

        header {
            text-align: center;
            margin-bottom: 3rem;
            padding-bottom: 2rem;
            border-bottom: 1px solid var(--border);
        }

        header h1 {
            font-size: 2.5rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
        }

        header p {
            color: var(--text-secondary);
            font-size: 1.1rem;
        }

        .content { display: flex; flex-direction: column; gap: 1.5rem; }

        h2 {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--accent);
            margin-top: 2rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid var(--accent);
        }

        h3 {
            font-size: 1.2rem;
            font-weight: 500;
            color: var(--text-primary);
            margin-top: 1.5rem;
            text-decoration: underline;
            text-underline-position: under;
        }

        p { margin-bottom: 1rem; }

        a { color: var(--accent); text-decoration: none; }
        a:hover { text-decoration: underline; }

        code {
            background-color: var(--bg-code);
            padding: 0.2em 0.4em;
            border-radius: 4px;
            font-family: 'SF Mono', Monaco, Consolas, monospace;
            font-size: 0.9em;
        }

        pre {
            background-color: var(--bg-code);
            border-radius: 8px;
            padding: 1rem;
            overflow-x: auto;
            position: relative;
            margin: 1rem 0;
        }

        pre code { background: none; padding: 0; font-size: 0.9rem; line-height: 1.5; }

        .copy-btn {
            position: absolute;
            top: 0.5rem;
            right: 0.5rem;
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 6px;
            padding: 0.4rem;
            cursor: pointer;
            opacity: 0;
            transition: opacity 0.2s, background-color 0.2s;
            color: var(--text-secondary);
        }

        pre:hover .copy-btn { opacity: 1; }
        .copy-btn:hover { background: var(--border); color: var(--text-primary); }
        .copy-btn.copied { color: #10b981; }

        details {
            background-color: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 8px;
            margin: 1rem 0;
            overflow: hidden;
        }

        summary {
            padding: 1rem;
            cursor: pointer;
            font-weight: 500;
            background-color: var(--bg-card);
            transition: background-color 0.2s;
        }

        summary:hover { background-color: var(--bg-code); }
        details > pre { margin: 0; border-radius: 0; border-top: 1px solid var(--border); }

        ul, ol { margin: 1rem 0; padding-left: 1.5rem; }
        li { margin-bottom: 0.5rem; }

        .markdown-alert {
            border-radius: 8px;
            padding: 1rem 1.25rem;
            margin: 1rem 0;
        }

        .markdown-alert p { margin-bottom: 0.5rem; }
        .markdown-alert p:last-child { margin-bottom: 0; }

        .markdown-alert-note {
            background-color: #e8f4fd;
            border-left: 4px solid #3498db;
        }

        .markdown-alert-tip {
            background-color: #e8faf0;
            border-left: 4px solid #2ecc71;
        }

        .markdown-alert-warning {
            background-color: #fef9e7;
            border-left: 4px solid #f39c12;
        }

        .markdown-alert-important {
            background-color: #fef3e2;
            border-left: 4px solid #e67e22;
        }

        .markdown-alert-caution {
            background-color: #fdeaea;
            border-left: 4px solid #e74c3c;
        }

        @media (prefers-color-scheme: dark) {
            .markdown-alert-note { background-color: #1e3a5f; }
            .markdown-alert-tip { background-color: #1a4d3a; }
            .markdown-alert-warning { background-color: #4d3d1a; }
            .markdown-alert-important { background-color: #4d3517; }
            .markdown-alert-caution { background-color: #4d1a1a; }
        }

        footer {
            margin-top: 4rem;
            padding-top: 2rem;
            border-top: 1px solid var(--border);
            text-align: center;
            color: var(--text-secondary);
            font-size: 0.9rem;
        }

        @media (max-width: 600px) {
            header h1 { font-size: 2rem; }
            .container { padding: 1.5rem 1rem; }
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>ollama</h1>
            <p>{{ description }}</p>
        </header>

        <main class="content">
{{ content }}
        </main>

        <footer>
            <p>Unofficial Debian package repository</p>
        </footer>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            hljs.highlightAll();

            document.querySelectorAll('.copy-btn').forEach(function(btn) {
                btn.addEventListener('click', function() {
                    const pre = btn.closest('pre');
                    const code = pre.querySelector('code');
                    const text = code.textContent;

                    navigator.clipboard.writeText(text).then(function() {
                        btn.classList.add('copied');
                        btn.innerHTML = '<svg viewBox="0 0 24 24" width="16" height="16"><path fill="currentColor" d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg>';
                        setTimeout(function() {
                            btn.classList.remove('copied');
                            btn.innerHTML = '<svg viewBox="0 0 24 24" width="16" height="16"><path fill="currentColor" d="M16 1H4c-1.1 0-2 .9-2 2v14h2V3h12V1zm3 4H8c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h11c1.1 0 2-.9 2-2V7c0-1.1-.9-2-2-2zm0 16H8V7h11v14z"/></svg>';
                        }, 2000);
                    });
                });
            });
        });
    </script>
</body>
</html>`;

function processMarkdown(content) {
  const frontmatterRegex = /^---\n([\s\S]*?)\n---\n?/;
  const match = content.match(frontmatterRegex);

  if (!match) {
    return { frontmatter: {}, content: content };
  }

  const frontmatter = {};
  const lines = match[1].split('\n');
  for (const line of lines) {
    const colonIndex = line.indexOf(':');
    if (colonIndex > 0) {
      const key = line.substring(0, colonIndex).trim();
      let value = line.substring(colonIndex + 1).trim();
      if (value.startsWith('"') && value.endsWith('"')) {
        value = value.slice(1, -1);
      }
      frontmatter[key] = value;
    }
  }

  const markdownContent = content.substring(match[0].length);
  return { frontmatter, content: markdownContent };
}

const inputPath = path.join(__dirname, "index.md");
const outputPath = path.join(__dirname, "_site", "index.html");

const markdownContent = fs.readFileSync(inputPath, "utf-8");
const { frontmatter, content: markdown } = processMarkdown(markdownContent);

const renderer = {
  code(token) {
    return highlightCode(token);
  }
};

markedInstance.use({ renderer });

const htmlContent = markedInstance.parse(markdown);
const output = template
  .replace("{{ title }}", frontmatter.title || "Documentation")
  .replace("{{ description }}", frontmatter.description || "")
  .replace("{{ content }}", htmlContent);

fs.writeFileSync(outputPath, output, "utf-8");

console.log(`Built ${outputPath}`);
