% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/01_AllMethods.R
\name{plotFamily}
\alias{plotFamily}
\title{It draws the profile of the exposome in an ExposomeSet}
\usage{
plotFamily(x, family, group, group2, scatter = TRUE, na.omit = TRUE)
}
\arguments{
\item{x}{\link{ExposomeSet} which exposome will be plotted.}

\item{family}{Name of the familty that will be drawn. \code{'all'} is
allowed to draw a grid with all the families.}

\item{group}{If set it displays the family grouped
by the given phenotype.}

\item{group2}{If set it displays the family grouped
by the given phenotype.}

\item{scatter}{(default \code{TRUE}) If the family to be plotted is
continuous, the samples will be shown.}

\item{na.omit}{(default \code{TRUE}) Do not show \code{NA} values.}
}
\value{
A \code{ggplot} object if a family was selected. \code{invisible()}
if argument \code{family} was set to \code{"all"}.
}
\description{
This function draw a profile of the full exposome into an \link{ExposomeSet}
or the profile of the exposures in a specific family. For continuous
families, box-plots are drawn; while  for categorical families accumulative
bar-charts.
}
\examples{
data("exposome")
plt <- plotFamily(expo, family = "Metals")
plt <- plt + ggplot2::ggtitle("Metals")
plt
plt <- plotFamily(expo, family = "Indoor air")
plt <- plt + ggplot2::ggtitle("Indoor air")
plt
}
\seealso{
\link{plotHistogram} to draw the shape of an exposure,
\link{plotMissings} to plot the missing data from an \link{ExposomeSet}
}
