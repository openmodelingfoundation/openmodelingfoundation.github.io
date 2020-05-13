# standards

A repository for standards related to accessibility, interoperability, documentation, and reuse of computational models. 

## About

The site is generated with [hugo](https://gohugo.io) using the [docsy](https://www.docsy.dev) theme

## Setup

### No Docker

Clone this repository `git clone --recurse-submodules -j8 git@github.com:openmodelingfoundation/openmodelingfoundation.github.io.git`

Install the extended version of hugo from the [releases page](https://github.com/gohugoio/hugo/releases).

Install yarn from your package manager or from the [yarn site](https://yarnpkg.com/getting-started/install).

Run `yarn install` in the base directory.

Use regular hugo commands to try visualize the site.

```bash
hugo serve     # dev server without drafts
hugo serve -D  # dev server with drafts
```

### Docker

To build and run a hugo server using the Makefile you can run

```
make serve
```

This will build and start a docker container with a hot-reloading `hugo server` 
that you can visit in your browser at `http://localhost:1313`

```
make shell
```

will open a shell into the hugo container
