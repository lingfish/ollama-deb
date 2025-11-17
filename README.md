# ollama-deb

![GitHub Release](https://img.shields.io/github/v/release/lingfish/ollama-deb)

This is a GitHub workflow to build Debian packages of [ollama](https://github.com/ollama/ollama/) based on tags.

It installs the same files as the binary tarballs that you can download from
[their releases page](https://github.com/ollama/ollama/releases), plus more.

The contents of the `.deb` file can be seen on the [releases page](https://github.com/lingfish/ollama-deb/releases).

It will also install, enable and start a systemd service, as well as add a system user to run ollama.  It also adds the
source documentation.

## Usage
### NEW! Use my APT repo!

[Click here](https://lingfish.github.io/ollama-deb/) to get instructions on repo usage.

**NOTE**: the `sources.list` codename has changed from Debian distro names (like `bookworm`) to `stable`. Ollama themselves
don't specify what releases/distros they support, so I've changed to using an agnostic one too. `bookworm` will remain for
a while, and then be removed.

### Manual deb file install
Head over to the [releases page](https://github.com/lingfish/ollama-deb/releases) to download.

The package depends on `sysuser-helper`, so either install that first, or install these release packages, and then run
`apt-get -f install`.

Alternatively, more recent versions of `apt` can handle `.deb` file installation, plus dependency
handling -- the magic trick is to put a path in front of the filename:

```shell
host [01:34 PM] [j:0] /tmp # apt install ./ollama_0.3.14_amd64.deb
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
Note, selecting 'ollama' instead of './ollama_0.3.14_amd64.deb'
The following additional packages will be installed:
  sysuser-helper
The following NEW packages will be installed:
  ollama sysuser-helper
0 upgraded, 2 newly installed, 0 to remove and 164 not upgraded.
Need to get 4,176 B/1,448 MB of archives.
After this operation, 2,014 MB of additional disk space will be used.
Do you want to continue? [Y/n]
Get:1 http://deb.debian.org/debian bookworm/main amd64 sysuser-helper all 1.3.9+really1.4.3 [4,176 B]
Get:2 /tmp/ollama_0.3.14_amd64.deb ollama amd64 0.3.14 [1,448 MB]
Fetched 4,176 B in 4s (1,074 B/s)
Selecting previously unselected package sysuser-helper.
(Reading database ... 423601 files and directories currently installed.)
Preparing to unpack .../sysuser-helper_1.3.9+really1.4.3_all.deb ...
Unpacking sysuser-helper (1.3.9+really1.4.3) ...
Selecting previously unselected package ollama.
Preparing to unpack /tmp/ollama_0.3.14_amd64.deb ...
Unpacking ollama (0.3.14) ...
Setting up sysuser-helper (1.3.9+really1.4.3) ...
Setting up ollama (0.3.14) ...
Created symlink /etc/systemd/system/default.target.wants/ollama.service → /lib/systemd/system/ollama.service.
Processing triggers for libc-bin (2.36-9+deb12u7) ...
```

The shared libraries that the ollama team put into their binary tarballs are now split into their own package.
