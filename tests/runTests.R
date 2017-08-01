# The tests will only be run if there is an environment variable called
# GOOGLE_API_KEY containing the public API key.

# Get the API key from the environment variable.
if (GoogleGenomics::authenticate()) {
  # Perform the tests
  library(testthat)
  test_check("GoogleGenomics")
  message("SUCCESS: All tests pass.")
} else {
  # Skip the tests
  warning(paste(
      "Public key unavailable for authentication with Google Genomics.",
      "Skipping tests..."))
}
