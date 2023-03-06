# Request results ----
initial_response <- read_html(search_url)

number_of_results <-
  initial_response %>%
  html_elements("div.table-counts p b") %>%
  .[2] %>%
  html_text2() %>%
  as.integer()

number_of_result_pages <-
  initial_response %>%
  html_elements("li.page-item a") %>%
  html_text() %>%
  as.integer() %>%
  max(na.rm = TRUE)


# Collect links from each page ----

jobs <- tibble(
  Title          = character(),
  EmploymentType = character(),
  Location       = character(),
  Closingdate    = character(),
  Agency         = character()
)

# loop through initial paginated results and store a combined data.frame
#  with all job postings
for (page in seq_along(1:number_of_result_pages)) {
  # access URL
  print(glue("Accessing page {page} results..."))
  url_local <- compose_search_url(url, page, agency_params)
  # parse results
  html_local <- read_html(url_local)
  print(glue("Parsing page {page} results..."))
  temp <- get_jobs_table_from_html(html_local)
  jobs <- bind_rows(jobs, temp)
}


# adjust structure of data.frame ----
jobs <-
  jobs %>%
  mutate(
    ClosingDate   = lubridate::mdy_hm(Closingdate),
    DateFirstRetrieved = Sys.Date()
  ) %>%
  select(
    Title,
    EmploymentType,
    Location,
    ClosingDate,
    Agency,
    Link,
    DateFirstRetrieved
  )


# save copy of the data.frame ----
write_csv(jobs, here(glue("data/raw/jobs_table_{timestamp()}.csv")))


# save consolidated dataset ----
new_jobs <-
  jobs %>%
  anti_join(jobs_saved, by = "Link")

jobs <-
  jobs_saved %>%
  bind_rows(new_jobs) %>%
  unique()

write_csv(jobs, here("data/clean/jobs.csv"))

# clean up environment
rm(initial_response, temp, page, url_local, html_local)
