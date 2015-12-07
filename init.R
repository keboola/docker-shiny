# install really required packages
install.packages(c('git2r', 'jsonlite', 'devtools', 'rJava', 'RJDBC'), repos = 'http://cran.us.r-project.org', dependencies = c("Depends", "Imports", "LinkingTo"), INSTALL_opts = c("--no-html"))

# install some commonly used packages
install.packages(c('stringr', 'corrgram', 'data.table', 'gbm', 'ggplot2', 'leaps', 'plyr', 'dplyr', 'ggvis', 'moments', 'Rcpp', 'data.table', 'quantreg', 'httr', 'caret'), repos = 'http://cran.us.r-project.org', dependencies = c("Depends", "Imports", "LinkingTo"), INSTALL_opts = c("--no-html"))

library('devtools')

# install the libraries required for shiny applications
devtools::install_github('cloudyr/aws.signature', ref = "master")
devtools::install_github('keboola/sapi-r-client', ref = "master")
devtools::install_github('keboola/provisioning-r-client', ref = "master")
devtools::install_github('keboola/redshift-r-client', ref = "master")
devtools::install_github('keboola/shiny-lib', ref = "master")

