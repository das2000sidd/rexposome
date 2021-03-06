#' @describeIn ExWAS Method to plot a manhatan plot for association between
#' exposures and phenitypes
#' @param object An object of class \code{ExWAS}, \code{mExWAS} or \code{nlExWAS}.
#' @param subtitles Character vector with the "subtitle" for each plot when
#' given more than one \code{ExWAS}.
#' @param color (optional) A vector of colors. The vector must have length
#' equal to the number of families. The vector must be names with the
#' name of the families.
#' @param exp.order (optional) Order of the exposures.
#' @param show.effective (default TRUE) draws a brown line on the
#' threshold given by the effective number of tests.
#' @param labels (optional) Character vector with the labels for each exposure.
#' It must be labeled vector.
setMethod(
    f = "plotExwas",
    signature = "ExWAS",
    definition = function(object, ..., subtitles, color, exp.order,
                          labels, show.effective = TRUE) {
        multiple <- FALSE
        if(missing(...)) {
            items <- list(object)
        } else {
            multiple <- TRUE
            items <- c(list(object), list(...))
        }

        if(!missing(subtitles)) {
            if(length(items) == 1) {
                warning("Given 'subtitles' when single 'ExWAS' present.",
                    "'subtitles' will not be used.")
            } else if(length(subtitles) != length(items)) {
                stop("Diffrent lenghts beween given objects and 'subtitles'.")
            }
        } else {
            subtitles <- NA
        }

        tbl <- data.frame(pvalue=0.0, effect=0.0, x2.5=0.0, x97.5=0.0, fm="",
                         dir="", lpv=0.01, exposure="", exposure_clean="",
                         family="", label="")

        for(ii in 1:length(items)) {
            it <- items[[ii]]
            tbli <- extract(it, sort = FALSE)
            colnames(tbli) <- c("pvalue", "effect", "x2.5", "x97.5")
            if(is.na(subtitles)) {
                ff <- as.character(it@formula)
                ff <- paste0(ff[2], ff[1], gsub(" ", "", ff[3]))
                tbli$fm <- ff
            } else {
                tbli$fm <- subtitles[ii]
            }
            tbli$lpv <- -log10(tbli$pvalue)
            tbli$dir[ is.na( tbli$effect ) ] <- "NA"
            tbli$dir[ tbli$effect < 0 ] <- "-"
            tbli$dir[ tbli$effect >= 0 ] <- "+"
            tbli$exposure <- rownames(tbli)
            tbli$exposure_clean <- sapply(strsplit(rownames(tbli), "\\$"), "[[", 1)
            tbli$family <- object@description[tbli$exposure_clean, 1]
            if(missing(labels)) {
                tbli$label <- sapply(strsplit(rownames(tbli), "\\$"), function( it ) {
                    ifelse(length( it ) == 1, it, paste0(it[1], " (", it[2], ")"))
                })
            } else {
                tbli$label <- sapply( strsplit( rownames( tbli ), "\\$" ), function( nm ) {
                    ex <- ifelse( nm[ 1 ] %in% names( labels ), labels[ nm[ 1 ] ], nm[ 1 ] )
                    if( length( nm ) == 2 ) {
                        ex <- paste0( ex, " (", nm[ 2 ], ")" )
                    }
                    ex
                })
            }
            tbl <- rbind(tbl, as.data.frame(tbli))
        }
        tbl <- tbl[-1, ]
        rownames(tbl) <- 1:nrow(tbl)
        colnames(tbli)[1:4] <- c("pvalue", "effect", "2.5", "97.5")

        nm <- unique(as.character(tbl$family))
        if(missing(color)) {
            colorPlte <- sample(grDevices::rainbow(length(nm)))
            names(colorPlte) <- nm
        } else {
            colorPlte <- color
            names(colorPlte) <- names(color)
        }

        tbl$family <- as.character(tbl$family)
        tbl$exposure <- as.character(tbl$exposure)
        tbl$fm <- as.character(tbl$fm)
        tbl$label <- as.character(tbl$label)
        tbl$dir <- as.character(tbl$dir)


        if(missing(exp.order)) {
            tbl <- tbl[order(tbl$family, tbl$exposure), ]
            tbl$exposure <- factor(tbl$exposure, levels = unique(tbl$exposure))
        } else {
            if(sum(exp.order %in% tbl$exposure) != length(exp.order)) {
                stop("Not all exposures in 'exp.order' are present in given 'ExWAS' objects.")
            }
            # tbl <- c_order(tbl, "fm", "exposure", exp.order)
            rownames( tbl ) <- tbl$exposure
            tbl <- tbl[ as.character( exp.order ), ]
            tbl$label <-  factor( tbl$label, tbl$label )
        }

        if(!multiple) {
            plt <- ggplot2::ggplot(as.data.frame(tbl), ggplot2::aes_string(x = "lpv", y = "label", color = "family", shape = "dir")) +
                ggplot2::geom_point() +
                ggplot2::theme_minimal() +
                ggplot2::theme(panel.spacing = ggplot2::unit(0.5, 'lines'),
                    strip.text.y = ggplot2::element_text(angle = 0)) +
                ggplot2::ylab("") +
                ggplot2::xlab(expression(-log10(pvalue))) +
                ggplot2::labs(colour="Exposure's Families", shape="Exposure's Effect") +
                ggplot2::scale_color_manual(breaks = names(colorPlte),
                    values = colorPlte) +
                ggplot2::theme(legend.position = "right")
        } else {
            plt <- ggplot2::ggplot(tbl, ggplot2::aes_string(x = "lpv", y = "label", color = "family", shape = "dir")) +
                ggplot2::geom_point() +
                ggplot2::theme_minimal() +
                ggplot2::theme(panel.spacing = ggplot2::unit(0.5, 'lines'),
                    strip.text.y = ggplot2::element_text(angle = 0)) +
                ggplot2::ylab("") +
                ggplot2::xlab(expression(-log10(pvalue))) +
                ggplot2::labs(colour="Exposure's Families", shape="Exposure's Effect") +
                ggplot2::scale_color_manual(breaks = names(colorPlte),
                    values = colorPlte) +
                ggplot2::facet_wrap(~fm) +
                ggplot2::theme(legend.position = "bottom")
        }
        if(object@effective != 0) {
            if(show.effective) {
                if(object@effective == -1) {
                    warning("Cannot show 'effective threshold' because it was ",
                            "not computed in 'exwas'.")
                } else {
                    plt <- plt + ggplot2::geom_vline(
                        xintercept = -log10(object@effective), colour="Brown")
                }
            }
        }

        return(plt)
})


xc_order <- function(x, var1, var2, val2) {
    x <- x[order(x[ , var1]), ]
    c <- unique(x[ , var1])
    t <- x[x[ , var1] == c[1], ]
    rownames(t) <- t[ , var2]
    t <- t[val2, ]
    if(length(c) == 1){
        return(t)
    } else {
        c <- c[-1]
    }
    for(cc in c) {
        tt <- x[x[ , var1] == cc, ]
        rownames(tt) <- tt[ , var2]
        tt <- tt[val2, ]
        t <- rbind(t, tt)
    }
    return(t)
}
