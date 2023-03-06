# create `jobs` data.frame by looping through each page of initial results
#  and scraping the relevant html <table> element

# Retrieve values from 'Agency' lookup to create URL ----
html <- read_html(url)

agency_names <-
  html %>%
  html_elements("li[data-filter='dropdown_field_2'] label") %>%
  html_text2()%>%
  str_extract(pattern = ".{1,}(?= \\()")

agency_values <-
  html %>%
  html_elements("li[data-filter='dropdown_field_2'] label input") %>%
  html_attr("value")

agencies <- data.frame(
  name  = agency_names,
  value = agency_values
)

searched_agencies_df <-
  agencies %>%
  filter(name %in% searched_agencies) %>%
  mutate(url_param = compose_agency_url_param(value))

# Compose URL for search ----
agency_params <-
  searched_agencies_df$url_param %>%
  paste0(collapse = "&")

search_url <- glue("{url}?page=1&employment_type_uids%5B%5D=91a54de2aaa2d20ecc2362f5fe275a1d&{agency_params}")

rm(html)
