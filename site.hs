--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
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

-- COMPILERS {{{

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
    compile $ pandocCompiler
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

  match (fromList ["favicon.png", "robots.txt"]) $ do
    route   idRoute
    compile copyFileCompiler

  match "img/*" $ do
    route   idRoute
    compile copyFileCompiler

  match "templates/*" $ compile templateBodyCompiler

-- }}}
