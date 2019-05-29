
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ruODK: An ODK Central OData client <img src="man/figures/ruODK.png" align="right" alt="Are you ODK?" width="120" />

[![GitHub
issues](https://img.shields.io/github/issues/dbca-wa/ruodk.svg?style=popout)](https://github.com/dbca-wa/ruODK/issues)
[![Travis build
status](https://travis-ci.org/dbca-wa/ruODK.svg?branch=master)](https://travis-ci.org/dbca-wa/ruODK)
[![Coverage
status](https://codecov.io/gh/dbca-wa/ruODK/branch/master/graph/badge.svg)](https://codecov.io/github/dbca-wa/ruODK?branch=master)

Especially in these trying times, it is important to ask: “R U ODK?”

ODK Central provides data through an OData API, which has a
comprehensive and interactive
[documentation](https://odkcentral.docs.apiary.io/#reference/odata-endpoints).

This package aims to provide an automatable, reproducible way to
retrieve data from ODK Central’s OData API in the R ecosystem.

## Installation

You can install ruODK from GitHub with:

``` r
# install.packages("remotes")
remotes::install_github("dbca-wa/ruODK")
```

## Use

### Set up ODK Central

First, we need some data to play with\!

The ODK Central [user
manual](https://docs.opendatakit.org/central-using/) provides up-to-date
descriptions of the steps below.

  - [Create a web user
    account](https://docs.opendatakit.org/central-users/#creating-a-web-user)
    on an ODK Central instance. Your username will be an email address.
  - Create a [project](https://docs.opendatakit.org/central-projects/)
    and give the web user the relevant permissions.
  - Create a Xform, e.g. using ODK Build, or use the provided example
    forms.
  - Publish the [form to ODK
    Central](https://docs.opendatakit.org/central-forms/).
  - Collect some data for this form on ODK Collect and let ODK Collect
    submit the finalised forms to ODK Central.
  - Get the ODK Central OData service URL for the form.

A note on the [included example
forms](https://github.com/dbca-wa/ruODK/tree/master/inst/extdata): The
`.odkbuild` versions can be loaded into [ODK
Build](https://build.opendatakit.org/), while the `.xml` versions can be
imported into ODK Central.

### Configure ruODK

For now, ODK Central supports BasicAuth (username and password).

We could supply those credentials to each `ruODK` function call, but
that’s cumbersome and not securely reproducible (the command would
include the sensitive credentials).

A better way is to set your ODK Central username (email) and password as
R environment variables, e.g. in your `~/.Rprofile` (to set them per
machine), or in a separate file (to set them per project).

`ruODK` functions default to use the R environment variables `ODKC_UN`
and `ODKC_PW` for authentication.

``` r
Sys.setenv(ODKC_UN="...@...")
Sys.setenv(ODKC_PW=".......")
```

### Use ruODK

ruODK aims to provide the same access to your submissions via ODK
Central’s OData service endpoints as MS Excel, MS PowerBI and Tableau.

At the end of this step, we want to achieve the same outcome as the
[manual download to
CSV](https://docs.opendatakit.org/central-submissions/#downloading-submissions-as-csvs).

A quick example:

``` r
library(ruODK)

# ODK Central credentials
if (file.exists("~/.Rprofile")) source("~/.Rprofile")

# ODK Central OData service URL
data_url <- "https://sandbox.central.opendatakit.org/v1/projects/14/forms/build_Flora-Quadrat-0-2_1558575936.svc"

# Download from ODK Central
meta <- data_url %>% get_metadata()
data <- data_url %>% get_submissions() %>% parse_submissions()
```

A more detailed walk-through with some data visualisation examples is
available in the `vignette("example")` or
[here](https://dbca-wa.github.io/ruODK/articles/example.html).

## Contribute

Contributions through issues and PRs are welcome\!

## Acknowledgements

The Department of Biodiversity, Conservation and Attractions (DBCA)
respectfully acknowledges Aboriginal people as the traditional owners of
the lands and waters it manages.

One of the Department’s core missions is to conserve and protect the
value of the land to the culture and heritage of Aboriginal people.

This software was created not only as a contribution to the ODK
ecosystem, but also for the conservation of the biodiversity of Western
Australia, and in doing so, caring for country.
