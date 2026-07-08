---
title: ollama Debian Package Repository
description: Unofficial Debian package repository documentation
---

> [!NOTE]
> The repo URL has moved from `ollama-repo.jason-9eb.workers.dev` to `packages.lingfish.net`.
> The old URL continues to work, but new installations should use the new URL.
> To update existing sources, run:
> ```bash
> sudo sed -i 's|ollama-repo.jason-9eb.workers.dev|packages.lingfish.net|g' /etc/apt/sources.list.d/ollama*.list /etc/apt/sources.list.d/ollama*.sources
> ```
>
> Then run `sudo apt update` to refresh your package lists.

> [!NOTE]
> The `sources.list` codename has changed from Debian distro names (like `bookworm`) to `stable`. Ollama themselves
> don't specify what releases/distros they support, so I've changed to using an agnostic one too. `bookworm` has been
> removed.
>
> The component has also changed from `main` to `non-free` to reflect the proprietary GPU libraries included in the
> packages.

## Overview

Setting up this repository involves three steps:

1. Add the GPG key
2. Add the repository source
3. Install ollama

This can be done manually, or you can use [extrepo](https://manpages.debian.org/trixie/extrepo/extrepo.1p.en.html) (1p).

## Repository setup

### Using extrepo

Make sure you have extrepo installed, and then enable `non-free` in `/etc/extrepo/config.yaml`:

```yaml
enabled_policies:
- main
# - contrib
- non-free
```

This is a quick `sed` if you want:

```console
root@host:/# sed -ie 's/^# - non-free$/- non-free/g' /etc/extrepo/config.yaml
```

Once done, you can use `search`, or just proceed with `enable`:

```console
root@host:/# extrepo search ollama
Found ollama:
---
contact: https://github.com/lingfish/ollama-deb/issues
description: |
  Ollama - Large Language Model server. Get up and running with
  Llama 3.2, Mistral, Gemma 2, and other large language models.
gpg-key-checksum:
  sha256: 5f7dfe78c12d73beab6afccaca230e73b542067cb6d64f593b9d64e3ebe531d4
gpg-key-file: ollama.asc
policy: non-free
source:
  Architectures: amd64 arm64
  Components: non-free
  Suites: stable
  Types: deb
  URIs: https://packages.lingfish.net/apt
```

Once you've done `enable`, don't forget to `apt update`.  Then proceed to [package installation](#package-installation).

### Manual repo setup

#### Add GPG key

```bash
curl https://raw.githubusercontent.com/lingfish/ollama-deb/refs/heads/main/repository-key.asc | sudo gpg -o /etc/apt/keyrings/ollama-repo.gpg --dearmor
```

#### Add repository

Click to expand which format you need:

<details>
<summary>Pre deb822 file format</summary>

```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/ollama-repo.gpg] https://packages.lingfish.net/apt stable non-free" | sudo tee /etc/apt/sources.list.d/ollama.list
```

</details>

<details>
<summary>New deb822 file format</summary>

```bash
cat <<EOF > /etc/apt/sources.list.d/ollama.sources
Types: deb
URIs: https://packages.lingfish.net/apt/
Suites: stable
Components: non-free
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/ollama-repo.gpg
EOF
```

</details>

Of course, you could just paste the above into your favourite editor and save as root.

#### Update package lists

```bash
sudo apt update
```

> [!NOTE]
> The repo URL used to be a Cloudflare worker (`ollama-repo.jason-9eb.workers.dev`). It now points to `packages.lingfish.net`. The old URL will continue to work. See [here](https://github.com/lingfish/ollama-deb/issues/5) for details.
> This URL points to a Cloudflare worker. I do this in my free time, and I'm not willing to pay for hosting the (abnormally-large) package files.

## Package installation

Install ollama directly from the repository:

```bash
sudo apt install ollama
```

> [!NOTE]
> The `ollama` package now depends on `libollama-common`, which provides CPU dispatch libraries and the Vulkan backend. CPU inference works out of the box — no GPU package required.
> 
> To add GPU acceleration, install one of the GPU backend packages listed below.

To use a GPU, you'll also need one of the following packages, depending on your GPU make:

- `libollama-nvidia` (recommended by default)
- `libollama-amd`

## Vulkan Support

On Linux, GPU acceleration via Vulkan requires a Vulkan ICD to be installed on your system. Depending on your hardware, you may need one of:
- `mesa-vulkan-drivers` (AMD/Intel GPUs)
- `nvidia-vulkan-icd` (NVIDIA GPUs)
- `amdvlk` (AMD GPUs — alternative to Mesa)

Install the appropriate driver package for your hardware. Ollama will automatically fall back to CPU mode if no Vulkan ICD is detected (and no `ollama-deb` GPU packages are installed).

## Release candidates

To receive release candidate (RC) versions, use the `rc` suite instead of `stable`:

<details>
<summary>Pre deb822 file format</summary>

```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/ollama-repo.gpg] https://packages.lingfish.net/apt rc non-free" | sudo tee /etc/apt/sources.list.d/ollama-rc.list
```

</details>

<details>
<summary>New deb822 file format</summary>

```bash
cat <<EOF > /etc/apt/sources.list.d/ollama-rc.sources
Types: deb
URIs: https://packages.lingfish.net/apt/
Suites: rc
Components: non-free
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/ollama-repo.gpg
EOF
```

</details>

## The Cloudflare worker

[//]: # (Due to the way APT repos work, and how hosting companies cost money, I came up with a novel way to "host" the repo.)

[//]: # ()

[//]: # (The repo is hosted on a Cloudflare R2 bucket — but only the repo skeleton files, not the &#40;massive&#41; deb files.)

[//]: # (> [!TIP])

[//]: # (> When APT requests a package file, the Cloudflare worker redirects the request to a GitHub Releases download URL. This keeps hosting costs minimal while still serving the actual package files from GitHub's infrastructure.)

The worker basically acts like a normal webserver.

This is the code for the Cloudflare worker:

```javascript
export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const key = decodeURIComponent(url.pathname.slice(1));

    switch (request.method) {
      case "GET":
        // if (key.includes("apt/pool/main/o/ollama/")) {
        //   // Extract the filename from the original URL
        //   const filename = key.split('/').pop()
           
        //   // Replace '~' with '-' in the version number
        //   const githubFormattedFilename = filename.replace('~', '-').replace('-rc', '.rc')
           
        //   // Construct the new URL
        //   const newUrl = `https://github.com/lingfish/ollama-deb/releases/download/v${githubFormattedFilename.replace(/^[^_]*_/, '').replace('_amd64.deb', '').replace('.rc', '-rc')}/` + githubFormattedFilename
        //   //return Response.redirect("https://github.com/lingfish/ollama-deb/releases/download/v0.11.5-rc2/ollama_0.11.5.rc2_amd64.deb", 302);
        //   console.log(newUrl);
        //   return Response.redirect(newUrl, 302);
        // }        
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