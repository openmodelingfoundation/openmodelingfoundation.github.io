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

To build the image run

```
docker-compose build
```

Then use `cli` to run the server

Note that you'll need to bind to `0.0.0.0` when running `hugo serve` for the port to be exposed

For example

```
./cli serve --bind 0.0.0.0
```

will make the web page accessible to your browser on `localhost:1313`
