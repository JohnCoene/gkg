
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/JohnCoene/gkg.svg?branch=master)](https://travis-ci.org/JohnCoene/gkg)
<!-- badges: end -->

# gkg

Call the Google Knowledge Graph API

## Installation

You can install the package from Github with:

``` r
# install.packages("remotes")
remotes::install_github("JohnCoene/gkg")
```

## Example

Only contains a single function: `gkg`, see man for details. You will
need credentials, which you can get for free, see [the
prerequisites](https://developers.google.com/knowledge-graph/prereqs).
By default, `gkg` looks for the api key as `GKG_API_KEY` environment
variable.

``` r
gkg("R Programming", languages = "en", types = "Person")
#>                vocab                          goog      entitysearchresult
#> 1 http://schema.org/ http://schema.googleapis.com/ goog:EntitySearchResult
#>        detaileddescription      resultscore             kg            id
#> 1 goog:detailedDescription goog:resultScore http://g.co/kg kg:/m/0bxzv0g
#>               name thing person           description
#> 1 Robert Gentleman Thing Person Canadian statistician
#>                                                                                                            detaileddescription_articlebody
#> 1 Robert Clifford Gentleman is a Canadian statistician and bioinformatician currently vice president of computational biology at 23andMe. 
#>                                         detaileddescription_url
#> 1 https://en.wikipedia.org/wiki/Robert_Gentleman_(statistician)
#>                                                                                    detaileddescription_license
#> 1 https://en.wikipedia.org/wiki/Wikipedia:Text_of_Creative_Commons_Attribution-ShareAlike_3.0_Unported_License
```
