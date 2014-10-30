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

.onLoad <- function(libname, pkgname) {
  currentOptions <- options()
  defaultOptions <- list(
    google_genomics_endpoint="https://www.googleapis.com/genomics/v1beta"
  )
  toset <- !(names(defaultOptions) %in% names(currentOptions))
  if(any(toset)) options(defaultOptions[toset])

  invisible()
}

.onAttach <- function(libname, pkgname) {
  packageStartupMessage(paste0(pkgname, ": Do not forget to authenticate.\n",
    "\tUse ", pkgname, "::authenticate(file=\"secretsFile.json\").\n",
    "\tSee method documentation on how to obtain the secretsFile.\n"))
}
