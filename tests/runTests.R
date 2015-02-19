# The tests will only be run if there is an environment variable called API_KEY_SERVER containing the public API key.

# Configure authentication
apiKey <- Sys.getenv("API_KEY_SERVER", unset=NA)
if (!is.na(apiKey) && nchar(apiKey)>0) {
  GoogleGenomics::authenticate(apiKey=apiKey)
  # Perform the tests
  library(testthat)
  test_check("GoogleGenomics")
} else {
  # Skip the tests
  message("Public key unavailable for authentication with Google Genomics. Skipping tests...")
}
