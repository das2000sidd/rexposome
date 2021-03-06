% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/01_AllMethods.R
\name{tableMissings}
\alias{tableMissings}
\title{It creates a vector with the amount of missing in an ExposomeSet}
\usage{
tableMissings(object, set, output = "n", sort = TRUE)
}
\arguments{
\item{object}{\link{ExposomeSet} which exposome will be plotted.}

\item{set}{Can be set to \code{"exposures"} or to \code{"phenotypes"}.}

\item{output}{(default \code{"n"}) Can be \code{"n"} for number of values,
and \code{"p"} for percentage.}

\item{sort}{(default \code{TRUE}) If \code{TRUE} the chart will be ordered
from the features with less missing data to the ones with more missing data.}
}
\value{
A numeric vector with number of missing values per exposure. The
vector is labeled with the exposure's names.
}
\description{
This function can be used to obtain a table with the missing data in
exposures and in phenotypes of an \link{ExposomeSet}.
}
\examples{
data("exposome")
# The included has no missing data
tableMissings(expo, set = "exposures")
tableMissings(expo, set = "phenotypes")
}
\seealso{
\link{plotFamily} to draw the profile of a family of exposures,
\link{plotHistogram} to draw the shape of an exposure,
\link{plotMissings} to draw a plot with the missing data an ExposomeSet,
\link{imputation} to impute missing data on the exposures of an ExposomeSet
}
