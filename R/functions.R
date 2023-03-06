# functions called by `scope-and-compare-jobs.R`

## create relevant urls ----
compose_agency_url_param <- function(agency_value){
  glue("dropdown_field_2_uids%5B%5D={agency_value}")
}

# TODO parameterize values for employment type and agency
compose_search_url <- function(url, page, agency_params){
  glue("{url}?page={page}&employment_type_uids%5B%5D=91a54de2aaa2d20ecc2362f5fe275a1d&{agency_params}")
}

## parse existing HTML response ----
get_job_agencies_from_html <- function(html){
  html %>%
    html_elements("table.table tr td.job-search-results-dropdown_field_2") %>%
    html_text2()
}

get_job_titles_from_html <- function(html){
  html %>%
    html_elements("table.table tr td.job-search-results-title a") %>%
    html_text2()
}

get_job_links_from_html <- function(html){
  html %>%
    html_elements("table.table tr td.job-search-results-title a") %>%
    html_attr("href")
}

## make GET request; parse response ----
get_job_agencies_from_url <- function(url){
  url %>%
    read_html() %>%
    get_job_agencies_from_html()
}

get_job_titles_from_url <- function(url){
  url %>%
    read_html() %>%
    get_job_titles_from_html()
}

get_job_links_from_url <- function(url){
  url %>%
    read_html() %>%
    get_job_links_from_html()
}



## parse jobs table ----

get_jobs_table_from_html <- function(html){
  html %>%
    html_element("div.job-search-results-table.job-search-results-content table.table") %>%
    html_table() %>%
    rename_with(dhrm.base::replace_special_chars) %>%
    mutate(Link = get_job_links_from_html(html))
}

get_jobs_table_from_url <- function(url){
  url %>%
    read_html() %>%
    get_jobs_table_from_html()
}


## accept job url; return requisition id ----

get_job_requisition_id <- function(html = NULL, url = NULL){
  if(!is.null(url)) html <- read_html(url)
  html %>%
    html_elements("li.job-component-requisition-identifier span") %>%
    html_text2() %>%
    as.numeric()
}
#get_job_requisition_id <- Vectorize(get_job_requisition_id)

## accept job url/html; return job_description ----

get_job_description_from_html <- function(job_html){
  html %>%
    html_elements("div.job-description")
}

get_job_description_from_url <- function(job_url){
  url %>%
    read_html() %>%
    html_elements("div.job-description")
}

## accept job_description_html; return tokens ----

job_description_has_tokens <- function(html = NULL, url = NULL){
  if(!is.null(url)) html <- read_html(url)
  number_of_tokens <-
    html %>%
    html_elements("div.job-description p strong") %>%
    length()
  return(number_of_tokens > 0)
}


xpath_token <- function(token, return_text_only = TRUE){
  glue("//div[@class='job-description']/p[strong[starts-with(text(),'{token}')]][string-length(text())>0]{if_else(return_text_only,'/text()','')}")
}


job_description_token__hiring_range <- function(html = NULL, url = NULL){
  if(!is.null(url)) html <- read_html(url)
  x <-
    html %>%
    html_elements(xpath = xpath_token("Hiring Range")) %>%
    html_text2() %>%
    trimws()
  if(identical(x,character(0))){
    return(NA_character_)
  } else {
    return(x)
  }
}

job_description_token__pay_band <- function(html = NULL, url = NULL){
  if(!is.null(url)) html <- read_html(url)
  x <-
    html %>%
    html_elements(xpath = xpath_token("Pay Band")) %>%
    html_text2() %>%
    trimws()
  if(identical(x,character(0))){
    return(NA_character_)
  } else {
    return(x)
  }
}

job_description_token__location <- function(html = NULL, url = NULL){
  if(!is.null(url)) html <- read_html(url)
  x <-
    html %>%
    html_elements(xpath = xpath_token("Location")) %>%
    html_text2() %>%
    trimws()
  if(identical(x,character(0))){
    return(NA_character_)
  } else {
    return(x)
  }
}

job_description_token__recruitment_type <- function(html = NULL, url = NULL){
  if(!is.null(url)) html <- read_html(url)
  x <-
    html %>%
    html_elements(xpath = xpath_token("Recruitment Type")) %>%
    html_text2() %>%
    trimws()
  if(identical(x,character(0))){
    return(NA_character_)
  } else {
    return(x)
  }
}




job_description_tokens <- function(html = NULL, url = NULL, return_type = "vector", requisition_id = ""){
  if(!is.null(url)) html <- read_html(url)
  if(job_description_has_tokens(html = html)){
    # store keys (that have corresponding values)
    these_keys <-
      html %>%
      html_elements(xpath = "//div[@class='job-description']/p[strong][string-length(text())>0]") %>%
      html_elements("strong") %>%
      html_text2() %>%
      dhrm.base::replace_special_chars()
    # select values for keys with values
    these_values <-
      html %>%
      html_elements(xpath = "//div[@class='job-description']/p[strong][string-length(text())>0]/text()") %>%
      html_text2() %>%
      trimws()
    if(return_type == "data.frame"){
      these_values <- data.frame(
        requisiton_id = requisition_id,
        key   = these_keys,
        value = these_values
      )
    } else {
      # assign names
      names(these_values) <- these_keys
    }
  } else{
    these_values <- NA
  }
  return(these_values)
}
