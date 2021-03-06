% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/handle_ru_datetimes.R
\name{handle_ru_datetimes}
\alias{handle_ru_datetimes}
\title{Parse datetimes of submission data according to a form schema.}
\usage{
handle_ru_datetimes(
  data,
  form_schema,
  orders = c("YmdHMS", "YmdHMSz", "Ymd HMS", "Ymd HMSz", "Ymd", "ymd"),
  tz = get_default_tz(),
  verbose = get_ru_verbose()
)
}
\arguments{
\item{data}{Submissions rectangled into a tibble. E.g. the output of
```
ruODK::odata_submission_get(parse = FALSE) %>%
ruODK::odata_submission_rectangle()
```}

\item{form_schema}{The `form_schema` for the submissions.
E.g. the output of `ruODK::form_schema()`.}

\item{orders}{(vector of character) Orders of datetime elements for
lubridate.
Default:
\code{c("YmdHMS", "YmdHMSz", "Ymd HMS", "Ymd HMSz", "Ymd", "ymd")}.}

\item{tz}{A timezone to convert dates and times to.
Read `vignette("setup", package = "ruODK")` to learn how `ruODK`'s
timezone can be set globally or per function.}

\item{verbose}{Whether to display debug messages or not.
Read `vignette("setup", package = "ruODK")` to learn how `ruODK`'s
verbosity can be set globally or per function.}
}
\value{
The submissions tibble with all date/dateTime columns mutated as
  lubridate datetimes.
}
\description{
`r lifecycle::badge("stable")`
}
\details{
For a given tibble of submissions, parse all columns which are
marked in the form schema as type "date" or "dateTime" using a set of
lubridate orders and a given timezone.
}
\examples{
\dontrun{
library(magrittr)
data("fq_raw")
data("fq_form_schema")

fq_with_dates <- fq_raw \%>\%
  ruODK::odata_submission_rectangle() \%>\%
  ruODK::handle_ru_datetimes(form_schema = fq_form_schema)

dplyr::glimpse(fq_with_dates)
}
}
\seealso{
Other utilities: 
\code{\link{attachment_get}()},
\code{\link{attachment_url}()},
\code{\link{drop_null_coords}()},
\code{\link{form_schema_parse}()},
\code{\link{get_one_attachment}()},
\code{\link{get_one_submission_attachment_list}()},
\code{\link{get_one_submission}()},
\code{\link{handle_ru_attachments}()},
\code{\link{handle_ru_geopoints}()},
\code{\link{handle_ru_geoshapes}()},
\code{\link{handle_ru_geotraces}()},
\code{\link{isodt_to_local}()},
\code{\link{odata_submission_rectangle}()},
\code{\link{predict_ruodk_name}()},
\code{\link{prepend_uuid}()},
\code{\link{ru_msg_abort}()},
\code{\link{ru_msg_info}()},
\code{\link{ru_msg_noop}()},
\code{\link{ru_msg_success}()},
\code{\link{ru_msg_warn}()},
\code{\link{split_geopoint}()},
\code{\link{split_geoshape}()},
\code{\link{split_geotrace}()},
\code{\link{strip_uuid}()},
\code{\link{tidyeval}},
\code{\link{unnest_all}()}
}
\concept{utilities}
