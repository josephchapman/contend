# contend

A series of unpublished devcontainer features for personal use.

No release workflow publishes these into containers nor tarballs. They are currently pulled and referenced locally.

`git clone` this repository:
```bash
$  mkdir -p ~/ConfigManagement/contend/ \
&& git clone https://github.com/josephchapman/contend.git ~/ConfigManagement/contend/
```

Create new project directory:
```bash
$  mkdir -p asdf/.devcontainer/; cd $_
```

Symlink to `contend`'s library of `src`:
```bash
$  ln -s ~/ConfigManagement/contend/src src
```

Create an initial `devcontainer.json` file (including `go` in this example):
```bash
$ tee devcontainer.json \
> /dev/null \
<<EOF
{
  "name": "Ubuntu",
  "image": "ubuntu:jammy",
  "remoteUser": "contend",
  "customizations": {
    "vscode": {
      "settings": {
        "terminal.integrated.profiles.linux": {
          "bash": {
            "path": "bash",
            "icon": "terminal-bash"
          }
        },
        "terminal.integrated.defaultProfile.linux": "bash"
      }
    }
  },
  "features": {
    "./src/go/": {},
    "./src/user/": {
      "username": "contend"
    },
    "./src/utils/": {}
  }
}
EOF
```
