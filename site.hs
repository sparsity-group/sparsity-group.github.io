--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid            ((<>))
import           Hakyll

import           System.FilePath.Posix  (takeBaseName, takeDirectory,
                                         (</>), takeFileName, splitPath,
                                         joinPath, replaceExtension)
import           System.Process         (system)

--------------------------------------------------------------------------------

-- ROUTES {{{

-- have clean URLs
-- from https://www.rohanjain.in/hakyll-clean-urls/
cleanRoute :: Routes
cleanRoute = customRoute createIndexRoute
  where
    createIndexRoute ident = takeDirectory p </> takeBaseName p </> "index.html"
                             where p = toFilePath ident

-- flatten everything to specified top directory levels
flatRoute :: Int -> Routes
flatRoute x = customRoute $ createFlatRoute
  where
    createFlatRoute ident = p' </> takeFileName p
                            where p' = joinPath $ take x $ splitPath p
                                  p = toFilePath ident

-- }}}

-- CONFIG {{{

config :: Configuration
config = defaultConfiguration
    { deployCommand = "./deploy" }

-- }}}

-- MAIN {{{

main :: IO ()
main = hakyllWith config $ do

  match "pages/*" $ do
    route   $ flatRoute 0 `composeRoutes` cleanRoute
    compile $ do
      identifier <- getUnderlying
      mdBibFile  <- getMetadataField identifier "bibfile"
      mdCslFile  <- getMetadataField identifier "cslfile"
      bibFile    <- case mdBibFile of
        Nothing  -> return "bib/default.bib"
        Just bib -> return bib
      cslFile    <- case mdCslFile of
        Nothing  -> return "csl/default.csl"
        Just csl -> return csl
      pandocBiblioCompiler
              cslFile bibFile
      >>= loadAndApplyTemplate "templates/default.html" defaultContext
      >>= relativizeUrls

  match (fromList ["index.md", "404.md"])  $ do
    route   $ setExtension "html"
    compile $ pandocCompiler
      >>= loadAndApplyTemplate "templates/default.html" defaultContext
      >>= relativizeUrls

  match "css/*" $ do
    route   idRoute
    compile compressCssCompiler

  let toCopy = "favicon.png" .||. "robots.txt" .||. "img/**" .||. "katex/**" .||. "js/**"
  match toCopy $ do
    route idRoute
    compile copyFileCompiler

  match "templates/*" $ compile templateBodyCompiler
  match "bib/*.bib" $ compile biblioCompiler
  match "csl/*.csl" $ compile cslCompiler

-- }}}
