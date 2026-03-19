---
title: ollama Debian Package Repository
description: Unofficial Debian package repository documentation
---

> [!NOTE]
> The `sources.list` codename has changed from Debian distro names (like `bookworm`) to `stable`. Ollama themselves don't specify what releases/distros they support, so I've changed to using an agnostic one too. `bookworm` will remain for a while, and then be removed.

## Overview

Setting up this repository involves three simple steps:

1. Add the GPG key
2. Add the repository source
3. Install ollama

## Repository setup

### Add GPG key

```bash
curl https://raw.githubusercontent.com/lingfish/ollama-deb/refs/heads/main/repository-key.asc | sudo gpg -o /etc/apt/keyrings/ollama-repo.gpg --dearmor
```

### Add repository

Click to expand which format you need:

<details>
<summary>Pre deb822 file format</summary>

```bash
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/ollama-repo.gpg] https://ollama-repo.jason-9eb.workers.dev/apt stable main" | sudo tee /etc/apt/sources.list.d/ollama.list
```

</details>

<details>
<summary>New deb822 file format</summary>

```bash
cat <<EOF > /etc/apt/sources.list.d/ollama.sources
Types: deb
URIs: https://ollama-repo.jason-9eb.workers.dev/apt/
Suites: stable
Components: main
Architectures: amd64
Signed-By: /etc/apt/keyrings/ollama-repo.gpg
EOF
```

</details>

Of course, you could just paste the above into your favourite editor and save as root.

### Update package lists

```bash
sudo apt update
```

> [!NOTE]
> The repo URL looks a bit unusual. See [here](https://github.com/lingfish/ollama-deb/issues/5) for details.
> This URL points to a Cloudflare worker. I do this in my free time, and I'm not willing to pay for hosting the (abnormally-large) package files.

## Package installation

Install ollama directly from the repository:

```bash
sudo apt install ollama
```

> [!WARNING]
> The first GPU package that this `ollama` package recommends is `libollama-nvidia`, and so if none are requested, this will be installed by default. If you don't need any GPU support, remove it afterwards, or add `--no-install-recommends` to your `apt` command.

To use a GPU, you'll also need one of the following packages, depending on your GPU make:

- `libollama-nvidia` (installed by default)
- `libollama-amd`

## Other notes

### APT pinning

If you don't want release candidates and only "stable" versions, add the following to, say, `/etc/apt/preferences.d/ollama`:

```
Package: /./
Pin: origin ollama-repo.jason-9eb.workers.dev
Pin: version /rc/
Pin-Priority: -1
```

And then just do the usual `apt update`.

### The Cloudflare worker

Due to the way APT repos work, and how hosting companies cost money, I came up with a novel way to "host" the repo.

The repo is hosted on a Cloudflare R2 bucket — but only the repo skeleton files, not the (massive) deb files.

> [!TIP]
> When APT requests a package file, the Cloudflare worker redirects the request to a GitHub Releases download URL. This keeps hosting costs minimal while still serving the actual package files from GitHub's infrastructure.

This is the code for the Cloudflare worker:

```javascript
export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const key = decodeURIComponent(url.pathname.slice(1));

    switch (request.method) {
      case "GET":
        if (key.includes("apt/pool/main/o/ollama/")) {
          const filename = key.split('/').pop()
          const githubFormattedFilename = filename.replace('~', '-').replace('-rc', '.rc')
          const newUrl = `https://github.com/lingfish/ollama-deb/releases/download/v${githubFormattedFilename.replace(/^[^_]*_/, '').replace('_amd64.deb', '').replace('.rc', '-rc')}/` + githubFormattedFilename
          return Response.redirect(newUrl, 302);
        }
        const object = await env.MY_BUCKET.get(key);

        if (object === null) {
          return new Response("Object Not Found", { status: 404 });
        }

        const headers = new Headers();
        object.writeHttpMetadata(headers);
        headers.set("etag", object.httpEtag);

        return new Response(object.body, { headers });

      default:
        return new Response("Method Not Allowed", {
          status: 405,
          headers: { Allow: "GET" },
        });
    }
  },
};
```
