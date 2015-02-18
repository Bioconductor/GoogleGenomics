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

#' Get one page of search results for a particular entity type from Google
#'   Genomics.
#'
#' In general, use higher level methods such as getReads and getVariants
#' instead.
#'
#' @param entityType Entities with a search API such as reads, variants,
#'   variantSets, etc...
#' @param body The body of the message to POST to the search endpoint.
#' @param fields The fields to be returned in the search response.
#' @param pageToken The page token. This can be NULL for the first page.
#'
#' @return The raw response converted from JSON to an R object.
#' @export
getSearchPage <- function(entityType, body, fields, pageToken) {

  if (missing(entityType)) {
    stop("Missing required parameter entityType")
  }
  if (missing(body)) {
    stop("Missing required parameter body")
  }
  if (missing(fields)) {
    stop("Missing required parameter fields")
  }
  if (missing(pageToken)) {
    stop("Missing required parameter pageToken")
  }

  queryParams <- list()
  queryConfig <- config()

  if (!is.null(fields)) {
    if (!grepl("nextPageToken", fields)) {
      fields <- paste(fields, "nextPageToken", sep=",")
    }
    queryParams <- list(fields=fields)
  }

  if (.authStore$use_api_key) {
    queryParams <- c(queryParams, key=.authStore$api_key)
  } else {
    queryConfig <- config(token=.authStore$google_token)
  }

  message(paste("Fetching", entityType, "page"))
  response <- POST(paste(getOption("google_genomics_endpoint"),
                         tolower(entityType),
                         "search",
                         sep="/"),
                   query=queryParams,
                   body=toJSON(body),
                   queryConfig,
                   add_headers("Content-Type"="application/json"))

  checkResponse(response)

  content(response)
}

checkResponse <- function(response) {
  messages = list()

  # Check for error messages in response body.
  # TODO: other API responses can succeed but still include warnings.
  #   Emit those here as well.
  if ("error" %in% names(content(response))) {
    messages <- c(messages, paste("ERROR:", content(response)$error[[3]]))
  }

  # Check for specific status codes for which we would like to return specific
  #   messages.
  if (403 == status_code(response)) {
    messages <- c(messages, "Do not forget to authenticate.",
                  "Use authenticate(file='secretsFile.json').",
                  "See method documentation on how to obtain the secretsFile.")
  }

  if (0 != length(messages)) {
    warning(paste(messages, collapse='\n'), immediate=TRUE)
  }

  # Lastly, emit a general message and stop for status code >= 300.
  stop_for_status(response)
}
