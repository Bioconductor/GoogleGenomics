.onAttach <- function(libname, pkgname) {
  packageStartupMessage(paste0(pkgname, ": Do not forget to authenticate.\n",
    "\tUse ", pkgname, "::authenticate(file=\"secretsFile.json\").\n",
    "\tSee method documentation on how to obtain the secretsFile.\n"))
}
