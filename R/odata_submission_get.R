#' Retrieve and rectangle form submissions, parse dates, geopoints, download and
#' link attachments.
#'
#' `r lifecycle::badge("stable")`
#'
#' @details \code{\link{odata_submission_get}} downloads submissions from
#' (default) the main form group (submission table) including any non-repeating
#' form groups, or from any other table as specified by parameter `table`.
#'
#' With parameter \code{parse=TRUE} (default), submission data is parsed into a
#' tibble. Any fields of type \code{dateTime} or \code{date} are parsed into
#' dates, with an optional parameter \code{tz} to specify the local timezone.
#'
#' A parameter \code{local_dir} (default: \code{media}) specifies a local
#' directory for downloaded attachment files.
#' Already existing, previously downloaded attachments will be retained.
#'
#' With parameter `wkt=TRUE`, spatial fields will be returned as WKT, rather
#' than GeoJSON. In addition, fields of type `geopoint` will be split into
#' latitude, longitude, and altitude, prefixed with the original field name.
#' E.g. a field `start_location` of type `geopoint` will be split into
#' `start_location_latitude`, `start_location_longitude`, and
#' `start_location_altitude`. The field name prefix will allow multiple fields
#' of type `geopoint` to be split into their components without naming
#' conflicts.
#'
#' Geotraces (lines) and gepshapes (polygons) will be retained in their original
#' format, plus columns of their first point's coordinate components as
#' provided by \code{\link{split_geotrace}} and \code{\link{split_geoshape}},
#' respectively.
#'
#' Entirely unpopulated form fields, as well as notes and form groups, will be
#' excluded from the resulting tibble.
#' Submitting at least one complete form instance will prevent the accidental
#' exclusion of an otherwise mostly empty form field.
#'
#' The only remaining manual step is to optionally join any sub-tables to the
#' master table.
#'
#' The parameter \code{verbose} enables diagnostic messages along the download
#' and parsing process.
#'
#' With parameter \code{parse=FALSE}, submission data is presented as nested
#' list, which is the R equivalent of the JSON structure returned from the API.
#' From there, \code{\link{odata_submission_rectangle}} can rectangle the data
#' into a tibble, and subsequent lines of \code{\link{handle_ru_datetimes}},
#' \code{\link{handle_ru_attachments}}, \code{\link{handle_ru_geopoints}},
#' \code{\link{handle_ru_geotraces}}, and \code{\link{handle_ru_geoshapes}}
#' parse dates, download and link file attachments, and extract coordinates from
#' geofields.
#' \code{ruODK} offers this manual and explicit pathway as an option to
#' investigate and narrow down unexpected or unwanted behaviour.
#'
#' @param table The submission EntityType, or in plain words, the table name.
#'   Default: \code{Submissions} (the main table).
#'   Change to \code{Submissions.GROUP_NAME} for repeating form groups.
#'   The group name can be found through \code{\link{odata_service_get}}.
#' @param skip The number of rows to be omitted from the results.
#'   Example: 10, default: \code{NA} (none skipped).
#' @param top The number of rows to return.
#'   Example: 100, default: \code{NA} (all returned).
#' @param count If TRUE, an \code{@odata.count} property will be returned in the
#'   response from ODK Central. Default: \code{FALSE}.
#' @param wkt If TRUE, geospatial data will be returned as WKT (Well Known Text)
#'   strings. Default: \code{FALSE}, returns GeoJSON structures.
#'   Note that accuracy is only returned through GeoJSON.
#' @param parse Whether to parse submission data based on form schema.
#'   Dates and datetimes will be parsed into local time.
#'   Attachments will be downloaded, and the field updated to the local file
#'   path.
#'   Point locations will be split into components; GeoJSON (\code{wkt=FALSE})
#'   will be split into latitude, longitude, altitude and accuracy
#'   (with anonymous field names), while WKT will be split into
#'   longitude, latitude,and altitude (missing accuracy) prefixed by
#'   the original field name.
#'   See details for the handling of geotraces and geoshapes.
#'   Default: TRUE.
#' @param download Whether to download attachments to \code{local_dir} or not.
#'   If in the future ODK Central supports hot-linking attachments,
#'   this parameter will replace attachment file names with their fully
#'   qualified attachment URL.
#'   Default: TRUE.
#' @param orders (vector of character) Orders of datetime elements for
#'   lubridate.
#'   Default:
#'   \code{c("YmdHMS", "YmdHMSz", "Ymd HMS", "Ymd HMSz", "Ymd", "ymd")}.
#' @param local_dir The local folder to save the downloaded files to,
#'   default: \code{"media"}.
#' @template param-pid
#' @template param-fid
#' @template param-url
#' @template param-auth
#' @template param-odkcv
#' @template param-tz
#' @template param-retries
#' @template param-verbose
#' @return A list of lists.
#' \itemize{
#'  \item \code{value} contains the submissions as list of lists.
#'  \item \code{@odata.context} is the URL of the metadata.
#'  \item \code{@odata.count} is the total number of rows in the table.
#' }
# nolint start
#' @seealso \url{https://odkcentral.docs.apiary.io/#reference/odata-endpoints/odata-form-service}
#' @seealso \url{https://odkcentral.docs.apiary.io/#reference/odata-endpoints/odata-form-service/data-document}
# nolint end
#' @family odata-api
#' @importFrom rlang %||%
#' @export
#' @examples
#' \dontrun{
#' # Set default credentials, see vignette "setup"
#' ruODK::ru_setup(
#'   svc = paste0(
#'     "https://sandbox.central.getodk.org/v1/projects/14/",
#'     "forms/build_Flora-Quadrat-0-2_1558575936.svc"
#'   ),
#'   un = "me@email.com",
#'   pw = "..."
#' )
#'
#' form_tables <- ruODK::odata_service_get()
#' data <- odata_submission_get() # default: main data table
#' data <- odata_submission_get(table = form_tables$url[1]) # same, explicitly
#' data_sub1 <- odata_submission_get(table = form_tables$url[2]) # sub-table 1
#' data_sub2 <- odata_submission_get(table = form_tables$url[3]) # sub-table 2
#'
#' # Skip one row, return the next 1 rows (top), include total row count
#' data <- odata_submission_get(
#'   table = form_tables$url[1],
#'   skip = 1,
#'   top = 1,
#'   count = TRUE
#' )
#' }
odata_submission_get <- function(table = "Submissions",
                                 skip = NULL,
                                 top = NULL,
                                 count = FALSE,
                                 wkt = FALSE,
                                 parse = TRUE,
                                 download = TRUE,
                                 orders = c(
                                   "YmdHMS",
                                   "YmdHMSz",
                                   "Ymd HMS",
                                   "Ymd HMSz",
                                   "Ymd",
                                   "ymd"
                                 ),
                                 local_dir = "media",
                                 pid = get_default_pid(),
                                 fid = get_default_fid(),
                                 url = get_default_url(),
                                 un = get_default_un(),
                                 pw = get_default_pw(),
                                 odkc_version = get_default_odkc_version(),
                                 tz = get_default_tz(),
                                 retries = get_retries(),
                                 verbose = get_ru_verbose()) {
  yell_if_missing(url, un, pw)

  #----------------------------------------------------------------------------#
  # Download submissions
  if (verbose == TRUE) ru_msg_info("Downloading submissions...")

  sub <- httr::RETRY(
    "GET",
    httr::modify_url(
      url,
      path = glue::glue(
        "v1/projects/{pid}/forms/{URLencode(fid, reserved = TRUE)}.svc/{table}"
      )
    ),
    query = list(
      `$skip` = skip %||% "",
      `$top` = top %||% "",
      `$count` = ifelse(count == FALSE, "false", "true"),
      `$wkt` = ifelse(wkt == FALSE, "false", "true")
    ),
    times = retries,
    httr::add_headers(Accept = "application/json"),
    httr::authenticate(un, pw)
  ) %>%
    yell_if_error(., url, un, pw) %>%
    httr::content(.)

  if (verbose == TRUE) ru_msg_success("Downloaded submissions.")

  if (parse == FALSE) {
    if (verbose == TRUE) ru_msg_success("Returning unparsed submissions.")
    return(sub)
  }

  #----------------------------------------------------------------------------#
  # Get form schema
  if (verbose == TRUE) ru_msg_info("Reading form schema...")

  fs <- form_schema(
    parse = TRUE,
    pid = pid,
    fid = fid,
    url = url,
    un = un,
    pw = pw,
    odkc_version = odkc_version,
    retries = retries
  )

  #----------------------------------------------------------------------------#
  # Parse submission data
  if (verbose == TRUE) ru_msg_info("Parsing submissions...")

  # Rectangle, handle date/times, attachments, geopoints, geotraces, geoshapes
  sub <- sub %>%
    odata_submission_rectangle(
      form_schema = fs,
      verbose = verbose
    ) %>%
    handle_ru_datetimes(
      form_schema = fs,
      verbose = verbose
    ) %>%
    { # nolint
      if (download == TRUE) {
        fs::dir_create(local_dir)
        handle_ru_attachments(
          data = .,
          form_schema = fs,
          local_dir = local_dir,
          pid = pid,
          fid = fid,
          url = url,
          un = un,
          pw = pw,
          retries = retries,
          verbose = verbose
        )
      } else {
        .
      }
    } %>%
    handle_ru_geopoints(
      form_schema = fs,
      wkt = wkt,
      verbose = verbose
    ) %>%
    handle_ru_geotraces(
      form_schema = fs,
      wkt = wkt,
      verbose = verbose,
      odkc_version = odkc_version
    ) %>%
    handle_ru_geoshapes(
      form_schema = fs,
      wkt = wkt,
      verbose = verbose,
      odkc_version = odkc_version
    )

  #
  # End parse submission data
  #----------------------------------------------------------------------------#
  if (verbose == TRUE) ru_msg_success("Returning parsed submissions.")
  sub
}

# usethis::use_test("odata_submission_get") # nolint
