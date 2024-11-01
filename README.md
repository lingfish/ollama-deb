# ollama-deb

This is a GitHub workflow to build Debian packages of ollama based on tags.

It installs the same files as the binary tarballs one can download from their GitHub page, plus more:

<details>

<summary>Package contents:</summary>

```shell
root@ollama-builder:/tmp# dpkg -L ollama
/.
/lib
/lib/systemd
/lib/systemd/system
/lib/systemd/system/ollama.service
/usr
/usr/bin
/usr/bin/ollama
/usr/lib
/usr/lib/ollama
/usr/lib/ollama/libcublas.so.11.5.1.109
/usr/lib/ollama/libcublas.so.12.4.2.65
/usr/lib/ollama/libcublasLt.so.11.5.1.109
/usr/lib/ollama/libcublasLt.so.12.4.2.65
/usr/lib/ollama/libcudart.so.11.3.109
/usr/lib/ollama/libcudart.so.12.4.99
/usr/share
/usr/share/doc
/usr/share/doc/ollama
/usr/share/doc/ollama/README.Debian
/usr/share/doc/ollama/changelog.gz
/usr/share/doc/ollama/copyright
/usr/share/doc/ollama/docs
/usr/share/doc/ollama/docs/README.md
/usr/share/doc/ollama/docs/api.md.gz
/usr/share/doc/ollama/docs/development.md.gz
/usr/share/doc/ollama/docs/docker.md
/usr/share/doc/ollama/docs/faq.md.gz
/usr/share/doc/ollama/docs/gpu.md.gz
/usr/share/doc/ollama/docs/images
/usr/share/doc/ollama/docs/images/ollama-keys.png
/usr/share/doc/ollama/docs/images/signup.png
/usr/share/doc/ollama/docs/import.md.gz
/usr/share/doc/ollama/docs/linux.md
/usr/share/doc/ollama/docs/modelfile.md.gz
/usr/share/doc/ollama/docs/openai.md.gz
/usr/share/doc/ollama/docs/template.md.gz
/usr/share/doc/ollama/docs/troubleshooting.md.gz
/usr/share/doc/ollama/docs/tutorials
/usr/share/doc/ollama/docs/tutorials/fly-gpu.md
/usr/share/doc/ollama/docs/tutorials/langchainjs.md.gz
/usr/share/doc/ollama/docs/tutorials/langchainpy.md.gz
/usr/share/doc/ollama/docs/tutorials/nvidia-jetson.md
/usr/share/doc/ollama/docs/tutorials.md
/usr/share/doc/ollama/docs/windows.md
/usr/share/doc-base
/usr/share/doc-base/ollama.ollama
/usr/lib/ollama/libcublas.so
/usr/lib/ollama/libcublas.so.11
/usr/lib/ollama/libcublas.so.12
/usr/lib/ollama/libcublasLt.so
/usr/lib/ollama/libcublasLt.so.11
/usr/lib/ollama/libcublasLt.so.12
/usr/lib/ollama/libcudart.so
/usr/lib/ollama/libcudart.so.11.0
/usr/lib/ollama/libcudart.so.12
```
</details>

It will also install, enable and start a systemd service, as well as add a system user to run ollama.  It also adds the
source documentation.

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
With respect to the shared libraries packaged by the ollama team, I don't know why they do this.  I've packaged them
here anyway, and updating your `ld.so.conf` etc is left as an exercise for the reader.  Realistically, there should be
a separate package for the libs.

Head over to the [releases page](https://github.com/lingfish/ollama-deb/releases) to download.
