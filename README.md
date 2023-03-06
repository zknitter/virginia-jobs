# job-search
Code to search `jobs.virginia.gov` in lieu of actual search features

## Overview
This repository contains R code that scrapes the `jobs.virginia.gov` website
and extracts data from individual job detail pages to create a navigable 
tabular result set. 

## Contents
This repository contains the following:

* `/Rmd` - A directory containing the R Markdown file used to create the site at ...
* `/R` - A directory containing all code used to scrape `jobs.virginia.gov` and 
restructure its output for use in the associated GitHub Pages site
* `/data` - A directory containing raw and clean versions of the data scaped from `jobs.virginia.gov`
* `/docs` - A destination directory for static HTML files distributed on GitHub Pages
 
## Getting Started
To use this code, complete the following steps:
1. Clone this repository
2. Open `job-search-positions.Rproj` in RStudio
3. In the Files window, open the `R` directory
4. Open each of the files named using the convention `step*`

**To generate a structured output HTML file containing active job postings**, 
run each `step` R script in numerical order beginning with `step0` and concluding
with `step4`. The resulting HTML file can be found in the `docs` directory.

**To adjust the search criteria used**, modify the values stored in the variable 
`searched_agencies` in `step0--set-parameters.R`. *Note:* A list of valid agency 
names is scraped from `jobs.virginia.gov` in `step1--create-search-url.R` and 
stored in the data.frame `agencies`. Those values can be used to modify 
`searched_agencies`.

