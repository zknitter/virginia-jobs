# * THIS SCRIPT WAS CREATED USING A CLI * #
# # # # # # # # # # # # # # # # # # # # # #
# Purpose ----
#  To scrape data from `jobs.virginia.gov` for specific agencies,
#  then generate a navigable static HTML page containing the output
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# Load packages ----
library(rmarkdown)
library(here)
library(rvest)
library(xml2)
library(stringr)
library(dplyr)
library(glue)
library(readr)


# Define global variables/parameters ----

# `searched_agencies` must match the `agency_names` variable. To recreate, call:
#   agency_names %>% shQuote(type = "sh") %>% paste0(collapse = ",\n") %>% clipr::write_clip()
searched_agencies <- c(
  # "Eastern Shore Community College",
  # "Patrick & Henry Community College",
  "Agriculture & Consumer Svcs",
  "Attorney General & Dept of Law",
  # "Blue Ridge Community College",
  # "Brightpoint Community College",
  # "Central Virginia Community College",
  # "Danville Community College",
  "Department of Accounts",
  "Department of Aviation",
  "Department of Fire Programs",
  "Department of Forensic Science",
  "Department of Forestry",
  "Department of General Services",
  "Department of Health",
  "Department of Juvenile Justice",
  "Department of Military Affairs",
  "Department of Motor Vehicles",
  "Department of Social Services",
  "Department of State Police",
  "Department of Taxation",
  "Department of the Treasury",
  # "Dept Behavioral Health/Develop",
  "Dept Conservation & Recreation",
  "Dept for Aging & Rehab Svcs",
  "Dept for Blind/Vision Impaired",
  "Dept for Deaf & Hard-of-Hearng",
  "Dept of Corr - Central Admin",
  "Dept of Criminal Justice Svcs",
  "Dept of Ed Central Operations",
  "Dept of Emergency Management",
  "Dept of Environmental Quality",
  "Dept of Health Professions",
  "Dept of Historic Resources",
  "Dept of Housing & Cmnty Devel",
  # "Dept of Human Resource Mgt",
  "Dept of Labor and Industry",
  # "Dept of Med Assistance Svcs",
  "Dept of Planning and Budget",
  "Dept of Prof & Occup Reg",
  "Dept of Rail & Public Trans",
  "Dept of Veterans Services",
  "Dept of Wildlife Resources",
  "Division of Capitol Police",
  "Frontier Culture Museum of VA",
  # "Germanna Community College",
  # "Honors College",
  "Indigent Defense Commission",
  # "J. Sargeant Reynolds Community College",
  "Jamestown-Yorktown Foundation",
  # "Laurel Ridge Community College",
  "Lieutenant Governor",
  # "Longwood University (Hirezon)",
  "Marine Resources Commission",
  # "Mountain Empire Community Coll",
  # "Mountain Gateway Community College",
  # "New College Institute",
  # "New River Community College",
  # "Norfolk State University",
  # "Northern VA Community College",
  "Office of State Inspector Gen",
  # "Paul D. Camp Community College",
  # "Piedmont Virginia Community College",
  # "Rappahannock Community College",
  # "Richard Bland College",
  "Shared Services Center",
  # "Southside Va Community College",
  # "Southwest Virginia Community College",
  "Supreme Court",
  "System Office",
  "The Library of Virginia",
  "The Science Museum of Virginia",
  # "The University of Virginia",
  # "The University of Virginia's College at Wise",
  # "Tidewater Community College",
  "Tobacco Rgn Revitalizatn Comm",
  # "UVA",
  "VA Dept of Transportation",
  "VA Information Tech Agency",
  # "VA School for the Deaf & Blind",
  "VA Workers' Compensation Comm",
  "VCCS-Fellowship",
  "Virginia Alcoholic Beverage Control Authority",
  "Virginia College Savings Plan",
  "Virginia Commonwealth University",
  "Virginia Employment Commission",
  # "Virginia Highlands Community College",
  # "Virginia Lottery",
  # "Virginia Military Institute",
  "Virginia Museum of Fine Arts",
  # "Virginia Peninsula Community College",
  "Virginia Racing Commission",
  "Virginia Retirement System",
  "Virginia State Bar"
  # "Virginia State University",
  # "Virginia Tech University",
  # "Virginia Western Community College",
  # "Wytheville Community College"
)

url <- "https://www.jobs.virginia.gov/jobs/search"


# Load user-defined functions ----
source(here("R/functions.R"))


# Load saved historical data from files ----
jobs_saved        <- read_csv(here("data/clean/jobs.csv"))
job_details_saved <- read_csv(here("data/clean/job_details.csv"))


