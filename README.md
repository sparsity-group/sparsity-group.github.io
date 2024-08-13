This site is built using [Hakyll](https://jaspervdj.be/hakyll/) and uses
[`stack`](https://docs.haskellstack.org/en/stable/README/) for building the
site. To develop this site you'll want to install Hakyll:

```
$ stack install hakyll
```

To build the `site` executable:

```
$ stack build site
```

To build the site into the `_site` directory:

```
$ stack exec site build
```


