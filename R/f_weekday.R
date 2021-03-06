#' Format Weekdays to One Letter Abbreviation
#'
#' Format long weekday name, integer, or date formats to a single capital letter.
#' Useful for plot scales as a way to save space.
#'
#' @param x A vector of weekday names, integers 1-12, or dates.
#' @param distinct logical.  If \code{TRUE} Sunday will be presented as \code{Su}
#' and Thursday as \code{Th}.
#' @param \ldots ignored.
#' @return Returns a single letter month abbreviation atomic vector.
#' @export
#' @rdname f_weekday
#' @examples
#' f_weekday(weekdays(x=as.Date(seq(7), origin="1950-01-07")))
#' f_weekday(weekdays(x=as.Date(seq(7), origin="1950-01-07")), TRUE)
#'
#' f_weekday(1:7)
#' f_weekday(1:7, TRUE)
#'
#' days <- seq(as.Date("2000/1/2"), by = "day", length.out = 7)
#' f_weekday(days)
#' f_weekday(days, TRUE)
#'
#' \dontrun{
#' if (!require("pacman")) install.packages("pacman")
#' pacman::p_load(tidyverse)
#'
#' set.seed(10)
#' dat <- data_frame(
#'     day = sample(weekdays(days), 10000, TRUE),
#'     area =  sample(LETTERS[1:15], 10000, TRUE)
#' ) %>%
#'     count(day, area) %>%
#'     ungroup() %>%
#'     mutate(
#'         day = factor(day, levels = weekdays(days))
#'     )
#'
#' ## without date formatting
#' ggplot(dat, aes(day, n)) +
#'     geom_bar(stat = 'identity') +
#'     facet_wrap(~area)
#'
#' ## with date formatting
#' ggplot(dat, aes(day, n)) +
#'     geom_bar(stat = 'identity') +
#'     facet_wrap(~area) +
#'     scale_x_discrete(labels = f_weekday)
#'
#' ## with date formatting
#' ggplot(dat, aes(day, n)) +
#'     geom_bar(stat = 'identity') +
#'     facet_wrap(~area) +
#'     scale_x_discrete(labels = ff_weekday(distinct = TRUE))
#' }
f_weekday <- function(x, distinct = FALSE, ...) {
    UseMethod('f_weekday')
}




#' @export
#' @rdname f_weekday
#' @method f_weekday default
f_weekday.default <- function(x, distinct = FALSE, ...) {
    if (distinct){
        locs <- match(
            gsub("(^.)(.)(.+)", "\\U\\1\\L\\2", as.character(x), perl = TRUE),
            short_weekdays_key
        )
        return(names(short_weekdays_key)[locs])
    }
    toupper(gsub("(^.)(.+)", "\\1", as.character(x)))
}

#' @export
#' @rdname f_weekday
#' @method f_weekday numeric
f_weekday.numeric <- function(x, distinct = FALSE, ...) {
    if (distinct) return(names(short_weekdays_key)[x])
    c("S", "M", "T", "W", "T", "F", "S")[x]
}




#' @export
#' @rdname f_weekday
#' @method f_weekday Date
f_weekday.Date <- function(x, distinct = FALSE, ...) {
    if (distinct){
        locs <- match(
            gsub("(^.)(.)(.+)", "\\U\\1\\L\\2", weekdays(x), perl = TRUE),
            short_weekdays_key
        )
        return(names(short_weekdays_key)[locs])
    }
    toupper(gsub("(^.)(.+)", "\\1", weekdays(x)))
}


#' @export
#' @rdname f_weekday
#' @method f_weekday POSIXt
f_weekday.POSIXt <- function(x, distinct = FALSE, ...) {
    if (distinct){
        locs <- match(
            gsub("(^.)(.)(.+)", "\\U\\1\\L\\2", weekdays(x), perl = TRUE),
            short_weekdays_key
        )
        return(names(short_weekdays_key)[locs])
    }
    toupper(gsub("(^.)(.+)", "\\1", weekdays(x)))
}

#' @export
#' @rdname f_weekday
#' @method f_weekday hms
f_weekday.hms <- function(x, distinct = FALSE, ...) {
    f_weekday.POSIXt(as.POSIXct(x))
}


#' @export
#' @rdname f_weekday
ff_weekday <- function(distinct = FALSE, ...) {
    function(x) {f_weekday(x, distinct = distinct)}
}



short_weekdays_key <- structure(c("Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"), .Names = c("Su",
"M", "T", "W", "Th", "F", "S"))







