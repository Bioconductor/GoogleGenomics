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
#' @param file Client secrets file obtained from Google Developer Console.
#'   If this file is not present, clientId and clientSecret must be provided.
#' @param clientId Client ID from Google Developer Console.
#' @param clientSecret Client Secret from Google Developer Console.
#' @param invokeBrowser If true, the default browser is invoked with the auth
#'   URL (default). If false, a URL is output which needs to be copy pasted in
#'   a browser. With both the options, you will still need to login to your
#'   Google account if not logged in already, and paste back the token key.
#' @param apiKey Public API key that can be used to call the Genomics API for
#'   public datasets. Providing this key overrides all other arguments.
#' @export
authenticate <- function(file, clientId, clientSecret, invokeBrowser=TRUE,
                         apiKey) {
  # If API key is provided, use it and ignore everything else.
  if (!missing(apiKey)) {
    .authStore$use_api_key <- TRUE
    .authStore$api_key <- apiKey

    return("Configured public API key.")
  } else {
    .authStore$use_api_key <- FALSE
  }

  # Read our oauth config from an external file if not passed in.
  if (!missing(file)) {
    clientSecrets <- fromJSON(file=file)
    clientId <- clientSecrets$installed$client_id
    clientSecret <- clientSecrets$installed$client_secret
  }

  # Get our oauth token.
  app <- oauth_app("google", clientId, clientSecret)
  .authStore$google_token <- oauth2.0_token(
      oauth_endpoints("google"), app,
      scope = "https://www.googleapis.com/auth/genomics",
      use_oob=!invokeBrowser)

  return("Configured OAuth token.")
}
