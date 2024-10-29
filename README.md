# ollama-deb

This is a GitHub workflow to build Debian packages of ollama based on tags.

It installs the same files as the binary tarballs one can download from their GitHub page:

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

It will also install, enable and start a systemd service, as well as add a system user to run ollama.

The package depends on `sysuser-helper`, so either install that first, or install these release packages, and then run
`apt-get -f install`.
