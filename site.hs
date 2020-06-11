--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import Hakyll
import Text.Pandoc.Options
import qualified Data.Set as S
import qualified GHC.IO.Encoding as E
import Data.Monoid (mappend, (<>))
import Data.List (isPrefixOf, isSuffixOf, sortBy)
import Control.Applicative
import System.FilePath.Posix  (takeBaseName, takeDirectory,
                               (</>), takeFileName, splitPath,
                               joinPath, replaceExtension)

--------------------------------------------------------------------------------
config :: Configuration
config = defaultConfiguration {
    destinationDirectory = "public",
    deployCommand = "./deploy"
  }

main :: IO ()
main = do
  E.setLocaleEncoding E.utf8
  hakyllWith config $ do
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match "js/*"$ do
      route idRoute
      compile copyFileCompiler

    match "js/vendor/*" $ do
      route idRoute
      compile copyFileCompiler

    match (fromList ["about-site.md"]) $ do
        route   $ cleanRoute
        compile $ pandocCompiler
          >>= loadAndApplyTemplate "templates/info.html" siteCtx
          >>= loadAndApplyTemplate "templates/default.html" siteCtx
          >>= relativizeUrls
          >>= cleanIndexUrls


    match "posts/*" $ do
        route   $ cleanRoute
        compile $ do
          postCompiler
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls
            >>= cleanIndexUrls

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
          >>= loadAndApplyTemplate "templates/info.html" siteCtx
          >>= loadAndApplyTemplate "templates/default.html" siteCtx
          >>= relativizeUrls
          >>= cleanIndexUrls

    create ["posts.html"] $ do
        route $ cleanRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let archiveCtx =
                    listField "posts" postCtx (return posts) <>
                    constField "title" "posts"            <>
                    siteCtx

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls
                >>= cleanIndexUrls

    match (fromList ["index.md", "404.md"]) $ do
      route $ setExtension "html"
      compile $ do
        pandocCompiler
          >>= loadAndApplyTemplate "templates/info.html" siteCtx
          >>= loadAndApplyTemplate "templates/default.html" siteCtx
          >>= relativizeUrls
          >>= cleanIndexUrls
{-
    match "index.html" $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let indexCtx =
                    listField "posts" postCtx (return posts) <>
                    constField "title" "homepage"             <>
                    siteCtx

            getResourceBody
              >>= applyAsTemplate indexCtx
              >>= loadAndApplyTemplate "templates/info.html" indexCtx
              >>= loadAndApplyTemplate "templates/default.html" indexCtx
              >>= relativizeUrls
-}
    match "templates/*" $ compile templateBodyCompiler
    match "csl/*.csl" $ compile cslCompiler
    match "bib/*.bib" $ compile biblioCompiler

    match ("CNAME"
          .||. "favicon.ico"
          .||. "robots.txt"
          .||. "404.html"
          .||. "humans.txt"
          .||. "icon.png"
          .||. "site.webmanifest"
          .||. "img/**") $ do
      route idRoute
      compile copyFileCompiler

--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
  dateField "date" "%B %e, %Y" <>
  siteCtx

siteCtx :: Context String
siteCtx =
  activeClassField <>
  defaultContext

activeClassField :: Context a
activeClassField = functionField "activeClass" $ \[p] _ -> do
  path <- toFilePath <$> getUnderlying
  return $ if path == p then "active" else "inactive"


postCompiler =
  let mathExtensions = [Ext_tex_math_dollars, Ext_tex_math_double_backslash,
                       Ext_latex_macros]
      defaultExtensions = writerExtensions defaultHakyllWriterOptions
      newExtensions = foldr S.insert defaultExtensions mathExtensions
      writerOptions = defaultHakyllWriterOptions {
        writerExtensions = newExtensions
        , writerHTMLMathMethod = MathJax ""
        , writerTableOfContents = True
        , writerTOCDepth = 3
        , writerTemplate = Just "<aside id=\"document-toc-container\"><section class=\"document-toc\"><header><h2>summary</h2></header>$if(toc)$$toc$$endif$</section></aside><div id=\"content\" ><article id=\"article\" >$body$</article>"
                                                 }
  in pandocCompilerWith defaultHakyllReaderOptions writerOptions

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


cleanIndexUrls :: Item String -> Compiler (Item String)
cleanIndexUrls = return . fmap (withUrls cleanIndex)

cleanIndexHtmls :: Item String -> Compiler (Item String)
cleanIndexHtmls = return . fmap (replaceAll pattern replacement)
    where
      pattern = "/index.html"
      replacement = const "/"

cleanIndex :: String -> String
cleanIndex url
    | idx `isSuffixOf` url = take (length url - length idx) url
    | otherwise            = url
  where idx = "index.html"
