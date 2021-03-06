% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/01_AllMethods.R
\name{plotCorrelation}
\alias{plotCorrelation}
\title{It draws both circos or matrix plot for the correlation in ExposomeCorr}
\usage{
plotCorrelation(object, type = "circos", ...)
}
\arguments{
\item{object}{\code{ExposomeCorr} which correlations will be plotted.}

\item{type}{(default \code{"circos"}) Can take both \code{"circos"} or
\code{"matrix"}.}

\item{...}{Arguments given to \code{corrplot} of package \link{corrplot}
if a matrix is draw. Moreover extra arguments are
can be passed to inner functions to draw both the matrix and the
circos of correlations.}
}
\value{
A \code{list} with different graphics parameters.
}
\description{
While the circos plot can be used to see the general behaviours intra and
extra families of exposures, the matrix plot allows for a detailed view of
the correlations within an \code{ExposomeCorr} object.
}
\examples{
data("exposome")
expo.c <- correlation(expo)
plotCorrelation(expo.c, type="circos")
plotCorrelation(expo.c, type="matrix")
}
\seealso{
\link{correlation} as a constructor for \link{ExposomeCorr}
objects, \link{pca} to compute PCA on exposures
}
