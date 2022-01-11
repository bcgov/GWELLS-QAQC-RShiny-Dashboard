logical_to_character_icon <- function(x){
  dplyr::if_else(x == TRUE,
                 as.character(icon("ok-sign", lib = "glyphicon")),
                 as.character(icon("exclamation-sign", lib = "glyphicon"))
  )
}


getAvailMem <- function(format = TRUE) {
  
  gc()
  
  if (Sys.info()[["sysname"]] == "Windows") {
    memfree <- 1024^2 * (utils::memory.limit() - utils::memory.size())
  } else {
    # http://stackoverflow.com/a/6457769/6103040
    memfree <- 1024 * as.numeric(
      system("awk '/MemFree/ {print $2}' /proc/meminfo", intern = TRUE))
  }
  
  `if`(format, format(structure(memfree, class = "object_size"),
                      units = "auto"), memfree)
}