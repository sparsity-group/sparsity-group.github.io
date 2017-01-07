--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll

import           System.FilePath.Posix  (takeBaseName, takeDirectory,
                                         (</>), takeFileName, splitPath)

--------------------------------------------------------------------------------

-- CUSTOM ROUTES {{{

-- have clean URLs
-- from https://www.rohanjain.in/hakyll-clean-urls/
cleanRoute :: Routes
cleanRoute = customRoute createIndexRoute
  where
    createIndexRoute ident = takeDirectory p </> takeBaseName p </> "index.html"
                            where p = toFilePath ident

-- flatten everything to top-level directory
flatRoute :: Routes
flatRoute = customRoute createFlatRoute
  where
    createFlatRoute ident = d!!0 </> takeFileName p
                            where d = splitPath p
                                  p = toFilePath ident

-- }}}

-- DEPLOY {{{
config :: Configuration
config = defaultConfiguration
    { deployCommand = "./deploy.sh" }
-- }}}

main :: IO ()
main = hakyllWith config $ do

  match (fromList ["about.md", "contact.md", "cv.md"]) $ do
    route   $ cleanRoute
    compile $ pandocCompiler
      >>= loadAndApplyTemplate "templates/default.html" defaultContext
      >>= relativizeUrls

  match "index.md" $ do
    route   $ setExtension "html"
    compile $ pandocCompiler
      >>= loadAndApplyTemplate "templates/default.html" defaultContext
      >>= relativizeUrls

  match "css/*" $ do
    route   idRoute
    compile compressCssCompiler

  match "files/**/*.pdf" $ do
    route   flatRoute
    compile copyFileCompiler

  match (fromList ["CNAME", "favicon.png", "robots.txt"]) $ do
    route   idRoute
    compile copyFileCompiler

  match "img/*" $ do
    route   idRoute
    compile copyFileCompiler

  match "templates/*" $ compile templateBodyCompiler

--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
  dateField "date" "%B %e, %Y" `mappend`
  defaultContext
