not_missing <- function(x) {
  !missing(x)
}

on_failure(not_missing) <- function(call, env) {
  paste0(
    "Missing `",
    crayon::blue(deparse(call$x)),
    "`."
  )
}

has_key <- function(x) {
  nchar(x) > 1
}

on_failure(has_key) <- function(call, env) {
  paste0(
    "Invalid `",
    crayon::blue(deparse(call$x)),
    "`."
  )
}