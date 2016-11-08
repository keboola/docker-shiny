#' Extension of keboola.r.docker.application 
#' Used to deploy apps to a shiny server
#' @import methods
#' @import keboola.r.docker.application
#' @field action A string from the configuration that tells the app what to do. 
#' The only possible action right now is list.  terminate and deploy are run asynchronously via the default run action. 
#' @field params A list of parameters found in the configuration
#' @export ShinyappDeployment
#' @exportClass ShinyappDeployment
ShinyappDeployment <- setRefClass(
    'ShinyappDeployment',
    contains = c("DockerApplication"),
    fields = list(
        action = 'character',
        appDir = 'character',
        params = 'list'
    ),
    methods = list(
        init = function(args) {
            callSuper(args)
            .self$readConfig(args)
            action <<- .self$getAction()
            params <<- .self$getParameters()
            appDir <<- .self$dataDir
        },
        
        run = function() {
            if (.self$params$command == "deploy") {
                # install packages
                if (length(.self$params$cranPackages) > 0) {
                    .self$installPackages(.self$params$cranPackages,"CRAN")
                }
                if (length(.self$params$githubPackages) > 0) {
                    .self$installPackages(.self$params$githubPackages, "github")
                }
                .self$deploy(.self$params$appName)
            } else if (.self$params$command == "delete") {
                .self$delete(.self$params$appName)
            }
        },
        
        list = function() {
            # list app dir contents
            dir(.self$appDir)
        },
    
        deploy = function() {
            tryCatch({
                creds <- NULL
                if (.self$params$password ) {
                    creds <- git2r::cred_user_pass(.self$params$user, .self$params$password)    
                } 
                git2r::clone(.self$params$repository,.self$appDir)
            }, error = function(e) {
                write(paste("Error deploying application:", e),stderr())
                stop(paste("shinyapp.deployment deploy error:", e))
            })
        }, 
        
        delete = function() {
            tryCatch({
                # delete the app from the directory
                unlink(.self$appDir)
                # rsconnect::terminateApp(.self$params$appName)
            }, error = function(e) {
                write(paste("Error archiving application", e), stderr())
                stop(paste("shinyapp.deployment archive error:", e))
            })
        },
        
        installPackages = function(packages, source = "CRAN") {
            # we need to install any github packages that we've been told to.
            packageList <- .self$trim(unlist(strsplit(packages,",")))
            
            lapply(packages, function(x){
                print(paste("Installing package",x,"from", source))
                if (source == "github") {
                    devtools::install_github(x, quiet = TRUE)    
                } else if (source == "CRAN") {
                    install.packages(x, verbose=FALSE, quiet=TRUE)   
                } else {
                    stop(paste("Sorry, I don't know how to install R packages from", source));
                }
            })
        },
        
        trim = function(x) {
            gsub("^\\s+|\\s+$", "", x)
        }
    )
)
