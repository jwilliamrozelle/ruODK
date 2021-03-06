% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/isodt_to_local.R
\name{isodt_to_local}
\alias{isodt_to_local}
\title{Parse an ISO8601 datetime string to a timezone aware datetime.}
\usage{
isodt_to_local(
  datetime_string,
  orders = c("YmdHMS", "YmdHMSz"),
  tz = get_default_tz()
)
}
\arguments{
\item{datetime_string}{(character) An ISO8601 datetime string as produced by
XForms exported from ODK Central.}

\item{orders}{(vector of character) Orders of datetime elements for
lubridate.
Default: \code{c("YmdHMS", "YmdHMSz", "Ymd HMS", "Ymd HMSz")}.}

\item{tz}{A timezone to convert dates and times to.
Read `vignette("setup", package = "ruODK")` to learn how `ruODK`'s
timezone can be set globally or per function.}
}
\value{
A lubridate PosixCT datetime in the given timezone.
}
\description{
`r lifecycle::badge("stable")`
}
\details{
This function is used internally by \code{ruODK} to parse ISO timestamps
to timezone-aware local times.
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
\code{\link{handle_ru_datetimes}()},
\code{\link{handle_ru_geopoints}()},
\code{\link{handle_ru_geoshapes}()},
\code{\link{handle_ru_geotraces}()},
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
\keyword{internal}
