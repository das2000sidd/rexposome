#' @describeIn ExposomePCA Number of principal components in an ExposomePCA.
setMethod(
    f = "ndim",
    signature="ExposomePCA",
    definition = function(object) {
        ncol(data.frame(object@pca$var$coord))
    }
)
