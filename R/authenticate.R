.authStore <- new.env()

#' Obtain auth token for Google Genomics API.
#' 
#' Follow the sign up instructions at \url{https://developers.google.com/genomics} to download
#'   the client secrets file, or note the clientId and clientSecret pair.
#' 
#' @param file Client secrets file obtained from Google Developer Console. 
#'   If this file is not present, clientId and clientSecret must be provided.
#' @param clientId Client ID from Google Developer Console.
#' @param clientSecret Client Secret from Google Developer Console.
#' @param invokeBrowser If true, the default browser is invoked with the auth URL (default).
#'   If false, a URL is output which needs to be copy pasted in a browser.
#'   With both the options, you will still need to login to your Google account if not logged
#'   in already, and paste back the token key.
#' @export
authenticate <- function(file, clientId, clientSecret, invokeBrowser=TRUE) {

  # Read our oauth config from an external file if not passed in.
  if(!missing(file)) {
    clientSecrets <- fromJSON(file=file)
    clientId <- clientSecrets$installed$client_id
    clientSecret <- clientSecrets$installed$client_secret
  }
  
  # Get our oauth token.
  app <- oauth_app("google", clientId, clientSecret)
  .authStore$google_token <- oauth2.0_token(oauth_endpoints("google"), app,
                                           scope = "https://www.googleapis.com/auth/genomics",
                                           use_oob=!invokeBrowser)
}
