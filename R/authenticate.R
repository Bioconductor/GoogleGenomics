# Copyright 2014 Google Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

.authStore <- new.env()
.authStore$use_api_key <- FALSE

#' Configure how to authenticate for Google Genomics API.
#'
#' Follow the sign up instructions at \url{https://developers.google.com/genomics}
#'   to download the client secrets file, or note the clientId and clientSecret
#'   pair.
#'
#' @param file Client secrets file obtained from Google Developer Console. This
#'   file could be for a native application or a service account. If this file
#'   is not present, clientId and clientSecret must be provided for native
#'   application credentials. Service account support needs version 0.1-2 or
#'   greater of \href{https://github.com/s-u/PKI}{PKI}.
#' @param clientId Client ID from Google Developer Console, overridden if file
#'   is provided.
#' @param clientSecret Client Secret from Google Developer Console, overridden
#'   if file is provided.
#' @param invokeBrowser If TRUE or not provided, the default browser is invoked
#'   with the auth URL iff the \code{\link[httpuv]{httpuv}} package is
#'   installed (suggested). If FALSE, a URL is output which needs to be copy
#'   pasted in a browser, and the resulting token needs to be pasted back into
#'   the R session. With both the options, you will still need to login to your
#'   Google account if not logged in already.
#' @param apiKey Public API key that can be used to call the Genomics API for
#'   public datasets. This method of authentication does not need you to login
#'   to your Google account. Providing this key overrides all other arguments.
#' @return NULL (silently) if successful.
#' @examples
#' apiKey <- Sys.getenv("GOOGLE_API_KEY")
#' if (!is.na(apiKey) && nchar(apiKey)>0) {
#'   authenticate(apiKey=apiKey)
#' }
#' \dontrun{
#' authenticate(file="clientSecrets.json")
#' authenticate(file="clientSecrets.json", invokeBrowser=FALSE)
#' authenticate(clientId="abc", clientSecret="xyz", invokeBrowser=FALSE)
#' }
#' @export
authenticate <- function(file, clientId, clientSecret,
                         invokeBrowser, apiKey) {
  # If API key is provided, use it and ignore everything else.
  if (!missing(apiKey)) {
    stopifnot(is.character(apiKey) && nchar(apiKey) > 0)
    .authStore$use_api_key <- TRUE
    .authStore$api_key <- apiKey

    message("Configured public API key.")
    return(invisible())
  } else {
    .authStore$use_api_key <- FALSE
  }

  # Read oauth config.
  serviceAccount <- FALSE
  if (!missing(file)) {
    clientSecrets <- fromJSON(file=file)
    serviceAccount <- !is.null(clientSecrets$type) &&
        clientSecrets$type == "service_account"
    if (!serviceAccount) {
      clientId <- clientSecrets$installed$client_id
      clientSecret <- clientSecrets$installed$client_secret
    }
  } else {
    stopifnot(!missing(clientId) && !missing(clientSecret))
  }

  # Get oauth token.
  endpoint <- oauth_endpoints("google")
  scope <- "https://www.googleapis.com/auth/genomics"
  if (!serviceAccount) {
    if (missing(invokeBrowser)) {
      invokeBrowser <- "httpuv" %in% rownames(installed.packages())
    }

    app <- oauth_app("google", clientId, clientSecret)
    .authStore$google_token <- oauth2.0_token(
        endpoint, app,
        scope=scope,
        use_oob=!invokeBrowser,
        cache=getOption("google_auth_cache"))
  } else {
    .authStore$google_token <- oauth_service_token(
        endpoint, clientSecrets, scope=scope)
  }

  message("Configured OAuth token.")
  return(invisible())
}

authenticated <- function() {
  return(.authStore$use_api_key || !is.null(.authStore$google_token))
}
