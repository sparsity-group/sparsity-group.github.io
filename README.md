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

The website files are deployed to my "Files" in my
[FastMail](https://www.fastmail.com/) account. This is done via the `deploy`
script in this repo. This script relies on getting the FTP credentials via the
[`keyring`](https://pypi.org/project/keyring/) module, so make sure that's
installed and the credentials are setup. If you need to reset the credentials
run the `reset_credentials.py` script.

To deploy the site, run:
```
$ stack exec site deploy
```
or simply
```
$ ./deploy
```

For math,

* The `katex` folder of the latest KaTex
  [release](https://github.com/Khan/KaTeX/releases) must be added to the root
  directory of this repo.
