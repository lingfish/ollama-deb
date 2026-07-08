# ollama-deb

> [!NOTE]
> ### `extrepo` now supported!
> For easier repo installation, you can now use `extrepo`.
> See the [documentation](https://lingfish.github.io/ollama-deb/) for details.

> [!NOTE]
> ### Repo URL migration
> The repo URL has moved from `ollama-repo.jason-9eb.workers.dev` to `packages.lingfish.net`.
> The old URL will continue to work, but new installations should use the new URL.
> See the [documentation](https://lingfish.github.io/ollama-deb/) for details.

> [!NOTE]
> ### Breaking repo changes!
> Whilst things were broken with the repo, I took the time to change some things:
> - You will need to update your `sources.list` to change from `main` to `non-free`.
> - `rc` builds are now in their own suite too, so there's no need anymore for previous `apt` pinning instructions
> (feel free, and I recommend, removing the pin file if you previously had one).
> - I will only be hosting the latest versions of released and `rc` packages.
> - As of 20 April, 2026, builds (and hence packages) were broken. This is due to the ollama team now pushing builds (specifically nvidia libraries) that are greater than 2GB in size,
> which breaks GitHub release upload limits. Therefore, packages cannot be uploaded to GitHub releases anymore, due to their size.
>
> Please see the [documentation](https://lingfish.github.io/ollama-deb/) for updated info.

![GitHub Release](https://img.shields.io/github/v/release/lingfish/ollama-deb)

This is a GitHub workflow to build Debian packages of [ollama](https://github.com/ollama/ollama/) based on tags.

It installs the same files as the binary tarballs that you can download from
[their releases page](https://github.com/ollama/ollama/releases), plus more.

It will also install, enable and start a service (`systemd` on systemd systems, `init.d` on sysvinit/OpenRC), as well as add a system user to run ollama. It also adds the
source documentation.

`amd64` and `arm64` architectures are packaged.

A [CHANGELOG](CHANGELOG.md) is maintained tracking packaging changes.

<a href="https://www.buymeacoffee.com/lingfish" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-red.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>

## Usage
### Use my APT repo

[Click here](https://lingfish.github.io/ollama-deb/) to get instructions on repo usage.

> [!NOTE]
> The `sources.list` codename has changed from Debian distro names (like `bookworm`) to `stable`. Ollama themselves don't
> specify what releases/distros they support, so I've changed to using an agnostic one too. `bookworm` will remain for a
> while, and then be removed.

The shared libraries that the ollama team put into their binary tarballs are now split into three packages:
- `libollama-common` (CPU dispatch + Vulkan) — required by `ollama`
- `libollama-nvidia` (CUDA backend) — optional
- `libollama-amd` (ROCm backend) — optional

CPU inference works out of the box. GPU packages are additive.

For Vulkan GPU acceleration on Linux, a Vulkan ICD driver must be installed separately. See [Vulkan Support](https://lingfish.github.io/ollama-deb/#vulkan-support) in the documentation.