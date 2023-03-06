# Reconcile current postings with stored values

# filter `jobs` to only new values
jobs_without_details <-
  new_jobs %>%
  filter(is.na(ClosingDate) | ClosingDate > Sys.Date())

job_details <- tibble(
  Link            = character(),
  RequisitionID   = double(),
  PayBand         = character(),
  HiringRange     = character(),
  RecruitmentType = character(),
  Location        = character()
)


for (i in jobs_without_details$Link) {
  print(glue("Checking URL --> {i}"))
  # error handling
  possible_error <- tryCatch(
    i_html <- read_html(i),
    error = function(e) e
  )
  if(inherits(possible_error, "error")){
    print("Skipping case due to error.")
    next
  } else {
    # scrape details if no 404 error
    i_html <- read_html(i)
    i_RequisitionID   <- get_job_requisition_id(html = i_html)
    i_PayBand         <- job_description_token__pay_band(html = i_html)
    i_HiringRange     <- job_description_token__hiring_range(html = i_html)
    i_RecruitmentType <- job_description_token__recruitment_type(html = i_html)
    i_Location        <- job_description_token__location(html = i_html)
    job_details <-
      job_details %>%
      add_row(
        Link            = i,
        RequisitionID   = i_RequisitionID,
        PayBand         = i_PayBand,
        HiringRange     = i_HiringRange,
        RecruitmentType = i_RecruitmentType,
        Location        = i_Location
      )
    print("Row added...")
    Sys.sleep(2)
  }
}

write_csv(job_details, here(glue("data/raw/job_details_{timestamp()}.csv")))

rm(
    i, i_HiringRange, i_html, i_Location, i_PayBand,
    i_RecruitmentType, i_RequisitionID
)


job_details <-
  job_details_saved %>%
  bind_rows(job_details) %>%
  unique()

write_csv(job_details, here("data/clean/job_details.csv"))
