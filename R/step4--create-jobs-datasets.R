# create combined `jobs` dataset

# Load saved data from files ----
jobs        <- read_csv(here("data/clean/jobs.csv"))
job_details <- read_csv(here("data/clean/job_details.csv"))


# Join data together and add calculated variables ----
jobs_data <-
  jobs %>%
  left_join(job_details, by = "Link", suffix = c("General", "Detail")) %>%
  unique() %>%
  mutate(
    Agency = str_replace(Agency, pattern = "Dept", replacement = "Department"),
    Status = case_when(
      DateFirstRetrieved == lubridate::ymd(Sys.Date()) ~ "New",
      ClosingDate <= Sys.Date() + 3 & ClosingDate > Sys.Date() ~ "Closing soon",
      ClosingDate < Sys.Date() ~ "Closed",
      .default = "Open"
    )
  ) %>%
  select(
    Title,
    # Agency,
    EmploymentType,
    PayBand,
    HiringRange,
    RecruitmentType,
    Status,
    ClosingDate,
    LocationGeneral,
    LocationDetail,
    Link,
    # DateFirstRetrieved
  )

jobs_data_current <-
  jobs_data %>%
  filter(Status != "Closed")


# Export CSV files ----
write_csv(jobs_data, here(glue("data/clean/jobs_data_{timestamp()}.csv")))
write_csv(jobs_data, here("data/clean/jobs_data.csv"))
write_csv(jobs_data_current, here("data/clean/jobs_data_current.csv"))


# Rebuild HTML output ----
render(here("Rmd", "jobs-data.Rmd"), output_dir = here("docs"))
