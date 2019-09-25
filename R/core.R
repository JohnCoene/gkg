#' Google Knowledge Graph
#' 
#' Call the Google Knowledge Graph API.
#' 
#' @param q The search query.
#' @param limit The maximum number of results to retrieve.
#' @param languages The list of language codes (defined in
#' ISO 639) to run the query with, for instance \code{en}.
#' @param types Restricts returned entities to those of the 
#' specified types. For example, you can specify \code{Person}
#' (as defined in \url{http://schema.org/Person}) to restrict
#' the results to entities representing people. If multiple 
#' types are specified, returned entities will contain one or 
#' more of these types.
#' @param prefix Enables prefix (initial substring) match 
#' against names and aliases of entities. For example, a prefix
#' \code{Jung} will match entities and aliases such as \code{Jung},
#' \code{Jungle}, and \code{Jung-ho Kang}.
#' @param key Your API key, defaults to looking for the 
#' \code{GKG_API_KEY} environment variable.
#' 
#' @import httr
#' @import purrr
#' @import assertthat
#' 
#' @export
gkg <- function(q, limit = 1L, languages = NULL, types = NULL, 
  prefix = NULL, key = Sys.getenv("GKG_API_KEY")){
  assert_that(not_missing(q))
  assert_that(has_key(key))

  types <- process_input(types, "types")
  languages <- process_input(languages, "languages")

  # prepare call
  uri <- parse_url(BASE_URL)
  uri$path <- BASE_PATH
  uri$query <- list(
    query = q,
    limit = limit,
    indent = FALSE,
    prefix = prefix,
    key = key
  )
  uri <- build_url(uri)
  uri <- paste0(uri, types)
  uri <- paste0(uri, languages)

  # call and extract content
  response <- GET(uri)
  warn_for_status(response)
  content <- content(response)

  if(!length(content$itemListElement))
    return(data.frame())
  
  quiet_dfr <- quietly(map_dfr)

  results <- content$itemListElement %>% 
    map("result") %>% 
    quiet_dfr(as.data.frame) %>% 
    .$result

  type <- as.data.frame(content[[1]])
  results <- cbind.data.frame(type, results)
  
  nms <- names(results)
  names(results) <- clean_names(nms)
  return(results)
}

BASE_URL <- "https://kgsearch.googleapis.com/"
BASE_PATH <- c("v1", "entities:search")

clean_names <- function(nms){
  nms %>% 
    gsub("^X\\.", "", .) %>% 
    gsub("^type\\.\\.", "", .) %>% 
    gsub("\\.$", "", .) %>% 
    gsub("[[:punct:]]", "_", .) %>% 
    tolower()
}

process_input <- function(x, what){
  if(is.null(x))
    return(NULL)

  what <- paste0("&", what, "=")
  
  paste0(x, collapse = what) %>% 
    paste0(what, .)
}

globalVariables(".")