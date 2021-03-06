#' @describeIn ExposomeSet Computes correlation on exposures.
setMethod(
    f = "correlation",
    signature = "ExposomeSet",
    definition = function(object, ..., warnings = TRUE) {
        cor.arg <- list()
        crm.arg <- list()
        lm.arg <- list()
        drop <- c("x", "y", "method")
        dots <- pryr::named_dots(...)
        for(name in names(dots)) {
            if(name %in% drop) {
                stop("Invalid argument '", name, "'. No arguments 'x', 'y' or ",
                    "'method' allowed. To add 'method' for 'lm' use 'method.lm'. ",
                    "To add 'method' for 'cor' use 'method.cor'.")
            }
            if(name %in% c(formalArgs(lm), "method.lm")) {
                if(name == "method.lm") { name <- "method" }
                    lm.arg[[name]] <- dots[[name]]
            } else if(name %in% c(formalArgs(cor), "method.cor")) {
                if(name == "method.cor") { name <- "method" }
                    cor.arg[[name]] <- dots[[name]]
            # } else if(name %in% formalArgs(chisq.test)) {
            #     chis.arg[[name]] <- dots[[name]]
            } else if(name %in% formalArgs(cramersV)) {
             crm.arg[[name]] <- dots[[name]]
            } else {
                stop("Argument '", name, "' do not corresponds to any argument ",
                "of 'cor', 'cramersV' nor 'lm' functions.")
            }
        }

        mtrc <- expos( object )
        cr <- .corr_exposures(mtrc, object, cor.arg, crm.arg, lm.arg, warnings)

        new("ExposomeCorr",
            assayData = assayDataNew("environment", corr = t(cr)),
            featureData = featureData(object)
        )
    }
)



.corr_exposures <- function(mtrc, object, cor.arg, crm.arg, lm.arg, warnings) {
    xx <- do.call(rbind, lapply(colnames(mtrc), function(ex_i) {
        ty_i <- fData(object)[ex_i, ".type"]
        yy <- vapply(colnames(mtrc), function(ex_j) {
            ty_j <- fData(object)[ex_j, ".type"]

            if(ty_i == "numeric" & ty_j == "numeric") {
                # Both exposures are numeric
                #   We can use the standard cor function for base
                do.call("cor", c(list(x = mtrc[ , c(ex_i, ex_j)]), cor.arg))[1, 2]
            } else if(ty_i == "factor" & ty_j == "factor") {
                # Both exposures are factor
                #   If both exposures are factorial we could use
                #   5th caramer factor as estimator for correlation.
                tryCatch({
                    do.call("cramersV", c(
                        list(x = table(mtrc[ , c(ex_i, ex_j)])), crm.arg))
                }, error=function(e) {
                    if(warnings) {
                        warning(ex_i, " - ", ex_j, ": ", e)
                    }
                    NA
                })

            } else {
                # One of the exposures is numeric and the other is facor
                #   If the factor exposures is multicategorical we can use the
                #   r from multiple regresion model as estimator for the
                #   correlation. An alternative could be to look for the eta of
                #   a one-way ANOVA.
                tryCatch({
                    fm <- paste(ex_i, "~", ex_j)
                    if(ty_i == "factor") {
                        fm <- paste(ex_j, "~", ex_i)
                    }
                    fm <- do.call("lm", c(list(formula = fm,
                        data = mtrc[ , c(ex_i, ex_j)]), lm.arg))
                    # lm.beta(fm)
                    sq <- sqrt(summary(fm)$r.squared)
                    ifelse(summary(fm)$coefficients[2,1] < 0, sq * -1, sq)
                }, error = function(e) {
                    if(warnings) {
                        warning(ex_i, " - ", ex_j, ": ", e)
                    }
                    NA
                })
            }
        }, FUN.VALUE = numeric(1))
        names(yy) <- colnames(mtrc)
        yy
    }))
    rownames(xx) <- colnames(mtrc)
    xx
}




