
<!-- README.md is generated from README.Rmd. Please edit that file -->

# `ruODK`: An R Client for the ODK Central API <img src="man/figures/ruODK.png" align="right" alt="Are you ODK?" width="120" />

<!-- badges: start -->

[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![GitHub
issues](https://img.shields.io/github/issues/dbca-wa/ruodk.svg?style=popout)](https://github.com/dbca-wa/ruODK/issues)
[![Travis build
status](https://travis-ci.org/dbca-wa/ruODK.svg?branch=master)](https://travis-ci.org/dbca-wa/ruODK)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/dbca-wa/ruODK?branch=master&svg=true)](https://ci.appveyor.com/project/dbca-wa/ruODK)
[![Coverage
status](https://codecov.io/gh/dbca-wa/ruODK/branch/master/graph/badge.svg)](https://codecov.io/github/dbca-wa/ruODK?branch=master)
<!-- badges: end -->

Especially in these trying times, it is important to ask: “ruODK?”

[OpenDataKit](https://opendatakit.org/) (ODK) is a free and open-source
software for collecting, managing, and using data in
resource-constrained environments.

ODK consists of a range of [software packages and
apps](https://opendatakit.org/software/). `ruODK` assumes some
familiarity of its users with the ODK ecosystem and workflows. For a
detailed overview, read the extensive [ODK
documentation](https://docs.opendatakit.org/) and visit the friendly
[ODK forum](https://forum.opendatakit.org/).

[ODK Central](https://docs.opendatakit.org/central-intro/) is a
cloud-based data clearinghouse for digitally captured data, replacing
the older software [ODK
Aggregate](https://docs.opendatakit.org/aggregate-intro/). ODK Central
manages user accounts and permissions, stores form definitions, and
allows data collection clients like [ODK
Collect](https://docs.opendatakit.org/collect-intro/) to connect to it
for form download and submission upload.

![An ODK setup with ODK Build, Central, Collect, and
ruODK](https://www.lucidchart.com/publicSegments/view/952c1350-3003-48c1-a2c8-94bad74cdb46/image.png)

A typical [ODK workflow](https://docs.opendatakit.org/#how-is-odk-used):
An XForm is designed e.g. in [ODK
Build](https://build.opendatakit.org/), [published to ODK
Central](https://docs.opendatakit.org/central-forms/), and downloaded
onto an Android device running ODK Collect. After data have been
captured digitally using [ODK
Collect](https://docs.opendatakit.org/collect-intro/), the data are
uploaded and stored in ODK Central. The next step from there is to
extract the data, optionally upload it into another data warehouse, and
then to analyse and generate insight from it.

While data can be retrieved in bulk through the GUI, ODK Central’s API
provides access to its data and functionality through both an OData and
a RESTful API with a comprehensive and interactive
[documentation](https://odkcentral.docs.apiary.io/#reference/odata-endpoints).

`ruODK` is aimed at the technically minded researcher who wishes to
access and use the data from ODK Central using the programming language
R.

Benefits of using the R ecosystem in combination with ODK:

  - Scalability: Both R and ODK are free and open source software.
    Scaling to many users does not incur license fees.
  - Ubiquity: R is known to many scientists and is widely taught at
    universities.
  - Automation: The entire data access workflow can be automated through
    R scripts.
  - Reproducible reporting (e.g. 
    [Sweave](https://support.rstudio.com/hc/en-us/articles/200552056-Using-Sweave-and-knitr),
    [RMarkdown](https://rmarkdown.rstudio.com/)), interactive web apps
    ([Shiny](https://shiny.rstudio.com/)), workflow scaling
    ([drake](https://docs.ropensci.org/drake/)) and a range of
    integrations with Docker (links coming soon).

`ruODK`’s scope:

  - To wrap all ODK Central API endpoints with a focus on **data
    access**.
  - To provide working examples of interacting with the ODK Central API.
  - To provide convenience helpers for the day to day tasks when working
    with ODK Central data in R: **data munging** the ODK Central API
    output into tidy R formats.

`ruODK`’s use cases:

  - Smaller projects:
    1.  Data collection: ODK Collect
    2.  Data clearinghouse: ODK Central
    3.  Data analysis and reporting: `Rmd` (ruODK)
    4.  Publishing and dissemination:
        [`ckanr`](https://docs.ropensci.org/ckanr/),
        [`CKAN`](https://ckan.org/)
  - Larger projects:
    1.  Data collection: ODK Collect
    2.  Data clearinghouse: ODK Central
    3.  ETL pipeline into data warehouses: `Rmd` (ruODK)
    4.  QA: in data warehouse
    5.  Reporting: `Rmd`
    6.  Publishing and dissemination:
        [`ckanr`](https://docs.ropensci.org/ckanr/),
        [`CKAN`](https://ckan.org/)

Out of scope:

  - To wrap “management” API endpoints. The ODK Central GUI provides a
    comprehensive interface for the management of users, roles,
    permissions, projects, and forms. Behind the scenes, it is a [VueJS
    application](https://github.com/opendatakit/central-frontend/)
    working on the “management” API endpoints of the ODK Central
    backend.
  - To provide extensive data visualisation. We show only minimal
    examples of data visualisation and presentation, mainly to
    illustrate the example data. Once the data is in your hands as tidy
    tibbles… u r ODK\!

## Install

You can install ruODK from GitHub with:

``` r
# install.packages("devtools")
remotes::install_github("dbca-wa/ruODK", dependencies = TRUE)
```

## ODK Central

### Access to an ODK Central instance

First, we need an ODK Central instance and some data to play with\!

Either ask in the \[ODK forum\] for an account in the [ODK Central
Sandbox](https://sandbox.central.opendatakit.org/), or follow the [setup
instructions](https://docs.opendatakit.org/central-intro/) to build and
deploy your very own ODK Central instance.

### ODK Central setup

The ODK Central [user
manual](https://docs.opendatakit.org/central-using/) provides up-to-date
descriptions of the steps below.

  - [Create a web user
    account](https://docs.opendatakit.org/central-users/#creating-a-web-user)
    on an ODK Central instance. Your username will be an email address.
  - [Create a project](https://docs.opendatakit.org/central-projects/)
    and give the web user the relevant permissions.
  - Create an Xform, e.g. using ODK Build, or use the provided example
    forms.
  - [Publish the form](https://docs.opendatakit.org/central-forms/) to
    ODK Central.
  - Collect some data for this form on ODK Collect and let ODK Collect
    submit the finalised forms to ODK Central.

A note on the [included example
forms](https://github.com/dbca-wa/ruODK/tree/master/inst/extdata): The
`.odkbuild` versions can be loaded into [ODK
Build](https://build.opendatakit.org/), while the `.xml` versions can be
imported into ODK Central.

## Configure `ruODK`

Set up `ruODK` with an OData Service URL and credentials of a
read-permitted ODK Central web user.

``` r
ruODK::ru_setup(
  svc = "https://sandbox.central.opendatakit.org/v1/projects/14/forms/build_Flora-Quadrat-0-2_1558575936.svc",
  un = Sys.getenv("ODKC_TEST_UN"),
  pw = Sys.getenv("ODKC_TEST_PW")
)
```

For all available detailed options to configure `ruODK`, read
`vignette("Setup", package = "ruODK")` (online
[here](https://dbca-wa.github.io/ruODK/articles/setup.html)).

## Use ruODK

A quick example using the OData service:

``` r
library(ruODK)

# List projects
proj <- ruODK::project_list()
proj %>% knitr::kable(.)
```

| id | name                                   | forms | app\_users | last\_submission    | created\_at         | updated\_at         | archived |
| -: | :------------------------------------- | ----: | ---------: | :------------------ | :------------------ | :------------------ | :------- |
|  8 | AmenazasRD                             |     0 |          0 | NA                  | 2019-04-14 06:21:00 | NA                  | FALSE    |
|  9 | BAFCO Test                             |     1 |          1 | 2019-04-19 01:26:49 | 2019-04-19 00:30:45 | NA                  | FALSE    |
| 11 | CaVaTeCo                               |     2 |          1 | 2019-04-30 08:07:55 | 2019-04-30 06:43:22 | NA                  | FALSE    |
| 18 | CherryPatch                            |     2 |          1 | 2019-05-28 17:32:15 | 2019-05-27 21:09:33 | 2019-05-29 20:08:10 | FALSE    |
| 32 | Collect3289v2                          |     1 |          2 | 2019-08-07 13:44:19 | 2019-08-07 12:52:56 | NA                  | FALSE    |
|  4 | Curso                                  |     7 |          4 | 2019-03-21 22:22:57 | 2019-02-26 03:55:50 | NA                  | FALSE    |
| 14 | DBCA WA                                |     8 |          3 | 2019-06-05 01:33:49 | 2019-05-17 03:10:51 | 2019-05-24 05:24:00 | FALSE    |
|  7 | DRC Test                               |     1 |          4 | 2019-05-07 13:14:01 | 2019-03-29 08:52:32 | NA                  | FALSE    |
| 24 | Farmers Survey                         |     1 |          0 | NA                  | 2019-06-25 15:51:47 | NA                  | FALSE    |
|  1 | Forms you made before projects existed |    44 |         28 | 2019-08-24 16:10:29 | 2019-02-14 17:28:00 | NA                  | FALSE    |
| 30 | FWW Epi Survey                         |     1 |          1 | 2019-08-06 17:19:15 | 2019-08-02 15:04:09 | NA                  | FALSE    |
|  6 | g                                      |     0 |          0 | NA                  | 2019-03-27 13:16:47 | NA                  | FALSE    |
| 23 | Guillermo’s tests                      |    44 |          0 | 2019-06-16 03:02:45 | 2019-06-15 11:30:05 | NA                  | FALSE    |
| 33 | issa test                              |     0 |          0 | NA                  | 2019-08-07 22:27:11 | NA                  | FALSE    |
| 26 | Kinshasa                               |     0 |          0 | NA                  | 2019-07-25 19:26:53 | NA                  | FALSE    |
| 34 | MBA                                    |     1 |          2 | 2019-08-13 03:30:17 | 2019-08-13 02:06:28 | NA                  | FALSE    |
|  2 | mon projet                             |     1 |          0 | NA                  | 2019-02-14 19:32:05 | NA                  | FALSE    |
|  3 | MyProjects                             |     0 |          1 | NA                  | 2019-02-25 19:31:40 | NA                  | FALSE    |
| 25 | Olivier38                              |     2 |          1 | 2019-07-27 20:14:39 | 2019-06-27 15:52:10 | NA                  | FALSE    |
| 21 | PresentationTest                       |     0 |          1 | NA                  | 2019-06-11 09:38:45 | NA                  | FALSE    |
| 13 | ProjetTest                             |     0 |          0 | NA                  | 2019-05-10 16:04:04 | NA                  | FALSE    |
| 22 | psud test                              |     1 |          2 | 2019-06-12 00:30:26 | 2019-06-12 00:20:02 | NA                  | FALSE    |
| 35 | Ronald Munjoma Test                    |     2 |          1 | NA                  | 2019-08-18 12:37:29 | NA                  | FALSE    |
| 29 | ✨Secret project ✨                      |     1 |          1 | NA                  | 2019-08-02 03:55:59 | NA                  | FALSE    |
|  5 | SurveyAir                              |     1 |          2 | 2019-04-11 07:36:35 | 2019-03-12 00:15:36 | NA                  | FALSE    |
| 16 | TBBT                                   |     1 |          1 | 2019-05-17 12:29:18 | 2019-05-17 12:21:50 | NA                  | FALSE    |
| 27 | Test form                              |     0 |          0 | NA                  | 2019-07-25 19:35:11 | NA                  | FALSE    |
| 10 | TestWFPProjects                        |     0 |          0 | NA                  | 2019-04-25 16:09:51 | NA                  | FALSE    |
| 28 | Tom Test                               |     2 |          1 | 2019-07-31 20:45:47 | 2019-07-31 20:08:20 | NA                  | FALSE    |
| 12 | UDA                                    |     3 |          2 | 2019-05-07 07:31:12 | 2019-05-02 14:52:35 | NA                  | FALSE    |
| 20 | UNCP-MW Test                           |     2 |          2 | 2019-06-06 00:36:20 | 2019-06-05 14:01:06 | 2019-06-05 18:19:14 | FALSE    |
| 36 | Yaw’s test                             |     1 |          1 | NA                  | 2019-09-02 22:59:35 | NA                  | FALSE    |
| 31 | Collect3289                            |     0 |          1 | NA                  | 2019-08-07 12:39:42 | 2019-08-07 12:52:50 | TRUE     |
| 17 | sdf                                    |     0 |          0 | NA                  | 2019-05-24 12:21:59 | 2019-05-24 12:23:09 | TRUE     |
| 15 | Turtles                                |     0 |          0 | NA                  | 2019-05-17 08:18:39 | 2019-05-24 05:25:34 | TRUE     |
| 19 | WatermelonPatch                        |     1 |          1 | 2019-05-29 19:50:50 | 2019-05-29 19:44:14 | 2019-05-29 20:06:46 | TRUE     |

``` r

# List forms of default project
frms <- ruODK::form_list()
frms %>% knitr::kable(.)
```

| name                          | fid                                              | version | state   | submissions | created\_at         | created\_by\_id | created\_by                    | updated\_at         | last\_submission    | hash                             |
| :---------------------------- | :----------------------------------------------- | :------ | :------ | :---------- | :------------------ | --------------: | :----------------------------- | :------------------ | :------------------ | :------------------------------- |
| Flora Quadrat 0.1             | build\_Flora-Quadrat-0-1\_1558330379             |         | closing | 1           | 2019-05-20 05:33:15 |              57 | <florian.mayer@dbca.wa.gov.au> | 2019-05-23 01:46:39 | 2019-05-20 05:44:20 | 4f0036619468ef05b572631b04b94f06 |
| Flora Quadrat 0.2             | build\_Flora-Quadrat-0-2\_1558575936             |         | open    | 2           | 2019-05-23 01:46:08 |              57 | <florian.mayer@dbca.wa.gov.au> | 2019-08-19 07:57:38 | 2019-05-23 03:12:16 | 14e269a2374132392c275117efbe67b6 |
| Flora Quadrat 0.3             | build\_Flora-Quadrat-0-3\_1559119570             |         | open    | 1           | 2019-05-29 08:48:15 |              57 | <florian.mayer@dbca.wa.gov.au> | NA                  | 2019-05-29 08:55:59 | d5a80cefb1895eefcd0cb86a12d8acb4 |
| Flora Quadrat 0.4             | build\_Flora-Quadrat-0-4\_1564384341             |         | open    | 0           | 2019-08-19 07:58:28 |              57 | <florian.mayer@dbca.wa.gov.au> | NA                  | NA                  | 1bb959d541ac6990e3f74893e38c855b |
| Spotlighting 0.5              | build\_Spotlighting-0-5\_1558320001              |         | closing | 1           | 2019-05-20 02:44:47 |              57 | <florian.mayer@dbca.wa.gov.au> | 2019-05-20 06:30:41 | 2019-05-20 02:58:09 | 3775dcdface98ba3a426739c494123f6 |
| Spotlighting 0.6              | build\_Spotlighting-0-6\_1558333698              |         | open    | 3           | 2019-05-20 06:30:21 |              57 | <florian.mayer@dbca.wa.gov.au> | NA                  | 2019-05-30 07:13:29 | 456daaa9a4f96670e6eef3cf4a7dd0db |
| Spotlighting Survey End 0.3   | build\_Spotlighting-Survey-End-0-3\_1558320208   |         | open    | 2           | 2019-05-20 02:44:38 |              57 | <florian.mayer@dbca.wa.gov.au> | NA                  | 2019-05-30 07:15:53 | 5fdfac8e773834b1267f7ca7e1c9a428 |
| Spotlighting Survey Start 0.3 | build\_Spotlighting-Survey-Start-0-3\_1558320795 |         | open    | 7           | 2019-05-20 02:53:50 |              57 | <florian.mayer@dbca.wa.gov.au> | NA                  | 2019-06-05 01:33:49 | f548a064cca13bca746f3c0b1a8b5a32 |

``` r

# Form details of default form
frmd <- ruODK::form_detail()
frmd %>% knitr::kable(.)
```

| name              | fid                                  | version | state | submissions | created\_at              | created\_by\_id | created\_by                    | updated\_at              | last\_submission         | hash                             |
| :---------------- | :----------------------------------- | :------ | :---- | ----------: | :----------------------- | --------------: | :----------------------------- | :----------------------- | :----------------------- | :------------------------------- |
| Flora Quadrat 0.2 | build\_Flora-Quadrat-0-2\_1558575936 |         | open  |           2 | 2019-05-23T01:46:08.474Z |              57 | <florian.mayer@dbca.wa.gov.au> | 2019-08-19T07:57:38.755Z | 2019-05-23T03:12:16.012Z | 14e269a2374132392c275117efbe67b6 |

``` r

# Form schema
meta <- ruODK::odata_metadata_get()
# listviewer::jsonedit(meta)
meta$Edmx$DataServices$Schema
#> $ComplexType
#> $ComplexType$Property
#> list()
#> attr(,"Name")
#> [1] "submissionDate"
#> attr(,"Type")
#> [1] "Edm.DateTimeOffset"
#> 
#> $ComplexType$Property
#> list()
#> attr(,"Name")
#> [1] "submitterId"
#> attr(,"Type")
#> [1] "Edm.String"
#> 
#> $ComplexType$Property
#> list()
#> attr(,"Name")
#> [1] "submitterName"
#> attr(,"Type")
#> [1] "Edm.String"
#> 
#> $ComplexType$Property
#> list()
#> attr(,"Name")
#> [1] "status"
#> attr(,"Type")
#> [1] "org.opendatakit.submission.Status"
#> 
#> attr(,"Name")
#> [1] "metadata"
#> 
#> $EnumType
#> $EnumType$Member
#> list()
#> attr(,"Name")
#> [1] "NotDecrypted"
#> 
#> $EnumType$Member
#> list()
#> attr(,"Name")
#> [1] "MissingEncryptedFormData"
#> 
#> attr(,"Name")
#> [1] "Status"
#> 
#> attr(,"Namespace")
#> [1] "org.opendatakit.submission"
#> attr(,"xmlns")
#> [1] "http://docs.oasis-open.org/odata/ns/edm"

# Form submissions
data <- ruODK::odata_submission_get() %>%
  ruODK::odata_submission_parse()
data %>% knitr::kable(.)
```

| id                                        | encounter\_start\_datetime    | reporter      | device\_id       | encounter\_end\_datetime      | submission\_date         | submitter\_id | submitter\_name | instance\_id                              | area\_name | quadrat\_photo    | type\_12 |      x13 |        x14 |  x15 | accuracy\_16 | morphological\_type | morphological\_type\_photo | vegclass\_placeholder                   | type\_20 |      x21 |        x22 |  x23 | accuracy\_24 | type\_25 |      x26 |        x27 |  x28 | accuracy\_29 | type\_30 |      x31 |        x32 |  x33 | accuracy\_34 | mudmap\_photo     | odata\_context                                                                                                              |
| :---------------------------------------- | :---------------------------- | :------------ | :--------------- | :---------------------------- | :----------------------- | :------------ | :-------------- | :---------------------------------------- | :--------- | :---------------- | :------- | -------: | ---------: | ---: | -----------: | :------------------ | :------------------------- | :-------------------------------------- | :------- | -------: | ---------: | ---: | -----------: | :------- | -------: | ---------: | ---: | -----------: | :------- | -------: | ---------: | ---: | -----------: | :---------------- | :-------------------------------------------------------------------------------------------------------------------------- |
| uuid:c0f9ce58-4388-4e7b-98d7-feac459d2e12 | 2019-05-23T10:46:04.821+08:00 | Florian Mayer | ccb596b33cd13298 | 2019-05-23T10:57:17.184+08:00 | 2019-05-23T03:12:16.012Z | 228           | manjimup        | uuid:c0f9ce58-4388-4e7b-98d7-feac459d2e12 | Kens1      | 1558579592153.jpg | Point    | 115.8840 | \-31.99618 |    0 |       41.909 | open-depression     | 1558579731266.jpg          | Lanscaped native shrubs over red gravel | Point    | 115.8840 | \-31.99612 |    0 |       40.977 | Point    | 115.8843 | \-31.99666 |    0 |       60.000 | Point    | 115.8841 | \-31.99613 |    0 |    72.900000 | 1558580082333.jpg | <https://sandbox.central.opendatakit.org/v1/projects/14/forms/build_Flora-Quadrat-0-2_1558575936.svc/$metadata#Submissions> |
| uuid:e0375332-0bb5-4175-a498-549bb33420e4 | 2019-05-23T10:58:34.541+08:00 | Florian Mayer | 351848090572014  | 2019-05-23T11:05:48.371+08:00 | 2019-05-23T03:07:34.385Z | 228           | manjimup        | uuid:e0375332-0bb5-4175-a498-549bb33420e4 | Kens02     | 1558580334821.jpg | Point    | 115.8843 | \-31.99621 | \-21 |       12.864 | flat                | 1558580394989.jpg          | Planter box over concrete pavers        | Point    | 115.8843 | \-31.99620 | \-22 |       12.864 | Point    | 115.8843 | \-31.99620 | \-22 |       15.008 | Point    | 115.8843 | \-31.99618 | \-26 |     9.648001 | 1558580571494.jpg | <https://sandbox.central.opendatakit.org/v1/projects/14/forms/build_Flora-Quadrat-0-2_1558575936.svc/$metadata#Submissions> |

A more detailed walk-through with some data visualisation examples is
available in the `vignette("odata", package="ruODK")` (online
[here](https://dbca-wa.github.io/ruODK/articles/odata.html)).

See also `vignette("restapi", package="ruODK")` (online
[here](https://dbca-wa.github.io/ruODK/articles/api.html)) for examples
using the alternative RESTful API.

## Contribute

Contributions through [issues](https://github.com/dbca-wa/ruODK/issues)
and PRs are welcome\!

See the [contributing
guide](https://dbca-wa.github.io/ruODK/CONTRIBUTING.html) on best
practices and further readings for code contributions.

## Attribution

`ruODK` was developed, and is maintained, by Florian Mayer for the
Western Australian [Department of Biodiversity, Conservation and
Attractions (DBCA)](https://www.dbca.wa.gov.au/). The development was
funded both by DBCA core funding and Offset funding through the [North
West Shelf Flatback Turtle Conservation
Program](https://flatbacks.dbca.wa.gov.au/).

To cite package `ruODK` in publications use:

``` r
citation("ruODK")
#> 
#> To cite ruODK in publications use:
#> 
#>   Florian W. Mayer (2019). ruODK: Client for the ODK Central API.
#>   R package version 0.6.1. https://github.com/dbca-wa/ruODK
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Misc{,
#>     title = {ruODK: Client for the ODK Central API},
#>     author = {Florian W. Mayer},
#>     note = {R package version 0.6.2},
#>     year = {2019},
#>     url = {https://github.com/dbca-wa/ruODK},
#>   }
```

## Acknowledgements

The Department of Biodiversity, Conservation and Attractions (DBCA)
respectfully acknowledges Aboriginal people as the traditional owners of
the lands and waters it manages.

One of the Department’s core missions is to conserve and protect the
value of the land to the culture and heritage of Aboriginal people.

This software was created both as a contribution to the ODK ecosystem
and for the conservation of the biodiversity of Western Australia, and
in doing so, caring for country.
