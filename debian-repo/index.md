---
title: ollama-deb
description: Unofficial Debian package repository documentation
layout: libdoc_page.liquid
permalink: index.html
---
{% alert "The `sources.list` codename has changed from Debian distro names (like `bookworm`) to `stable`. Ollama themselves don't specify what releases/distros they support, so I've changed to using an agnostic one too. `bookworm` will remain for a while, and then be removed.", 'warning', 'NOTE!' %}

## Overview of steps
1. {% iconCard 'GPG key', 'Add the repository GPG key', 'lock-simple' %}
2. {% iconCard 'Debian repo file', 'Add the Debian `sources` file', 'link-simple' %}
3. {% iconCard 'Install `ollama`', 'Install `ollama` and appropriate GPU library', 'arrow-line-down' %}
4. {% iconCard 'Enjoy a clean install & updates', 'All future `ollama` updates will install automatically!', 'rocket' %}

## Repository setup
Run the following comands to setup the repo:

### Add GPG key
```bash
curl https://raw.githubusercontent.com/lingfish/ollama-deb/refs/heads/main/repository-key.asc | sudo gpg -o /etc/apt/keyrings/ollama-repo.gpg --dearmor 
```

### Add repository
Click to expand which format you need:

            <details name="repo">
                <summary>Pre deb822 file format</summary>
<pre><code class="language-bash">echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/ollama-repo.gpg] https://ollama-repo.jason-9eb.workers.dev/apt stable main" | sudo tee /etc/apt/sources.list.d/ollama.list</code></pre>
            </details>

            <details name="repo">
                <summary>New deb822 file format</summary>
<pre><code class="language-bash">cat &lt;&lt;EOF &gt; /etc/apt/sources.list.d/ollama.sources
Types: deb
URIs: https://ollama-repo.jason-9eb.workers.dev/apt/
Suites: stable
Components: main
Architectures: amd64
Signed-By: /etc/apt/keyrings/ollama-repo.gpg
EOF</code></pre>
            </details>

Of course, you could just paste the above into your favourite editor and save as root.

### Update package lists
```bash
sudo apt update
```

{% alertAlt 'info', 'Note' %}
I realise that the repo URL looks weird. See [here](https://github.com/lingfish/ollama-deb/issues/5) for details, as well as below.
This URL is pointing to a Cloudflare worker. I do this in my free time, and I'm not willing to pay for any hosting
of the (abnormally-large) package files.
{% endalertAlt %}

## Package installation
Install packages directly from the repository:

```bash
sudo apt install ollama
```

{% alertAlt 'info', 'Note' %}
The first GPU package that this `ollama` package recommends is `libollama-nvidia`, and so if none are requested, this will be installed by default.
If you don't need any, remove it afterwards, or add `--no-install-recommends` to your `apt` command.

To use a GPU, you'll also need one of the following packages, depending on your GPU make:

* `libollama-nvidia` (installed by default)
* `libollama-amd`
{% endalertAlt %}

## Other notes
### APT pinning
If you don't want the release candidates, and only "stable" versions, try the following in, say, `/etc/apt/preferences.d/ollama`:

```
Package: /./
Pin: origin ollama-repo.jason-9eb.workers.dev
Pin: version /rc/
Pin-Priority: -1
```

And then just do the usual `apt update`.

### The CloudFlare worker
Due to the way APT repos work, and how hosting companies cost money, I came up with a novel way to "host" the repo.

The repo is hosted on a CloudFlare R2 bucket -- but only the repo skeleton files, not the (massive) deb files.

This is the code for the CF worker. Nothing fancy:

```javascript
export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const key = decodeURIComponent(url.pathname.slice(1));

    switch (request.method) {
      case "GET":
        if (key.includes("apt/pool/main/o/ollama/")) {
          // Extract the filename from the original URL
          const filename = key.split('/').pop()
          
          // Replace '~' with '-' in the version number
          const githubFormattedFilename = filename.replace('~', '-').replace('-rc', '.rc')
          
          // Construct the new URL
          const newUrl = `https://github.com/lingfish/ollama-deb/releases/download/v${githubFormattedFilename.replace(/^[^_]*_/, '').replace('_amd64.deb', '').replace('.rc', '-rc')}/` + githubFormattedFilename
          console.log(newUrl);
          return Response.redirect(newUrl, 302);
        }
        const object = await env.MY_BUCKET.get(key);

        if (object === null) {
          return new Response("Object Not Found", { status: 404 });
        }

        const headers = new Headers();
        object.writeHttpMetadata(headers);
        headers.set("etag", object.httpEtag);

        return new Response(object.body, {
          headers,
        });

      default:
        return new Response("Method Not Allowed", {
          status: 405,
          headers: {
            Allow: "GET",
          },
        });
    }
  },
};
```
