#' Formato para entrega de atividades (PDF)
#'
#' Essa função cria um formato R Markdown para gerar documentos de resolução de
#' atividades para aulas de laboratório.
#'
#' @examples
#' \dontrun{
#' # ---
#' # title: "Atividade 1"
#' # author: "Seu nome e sobrenome"
#' # output: mschuindt::pdf_atividade
#' # ---
#' }
#' @export
pdf_atividade <- function() {
  output_format(
    knitr = knitr_options(opts_chunk = list(dev = 'tikz', fig.dim = c(4, 4))),
    pandoc = pandoc_options(
      to = "pdf",
      lua_filters = pkg_file("lua/tcolorbox.lua"),
      args = c("--include-in-header", pkg_file("latex/preamble.tex"),
               "--pdf-engine=lualatex", "--listings")
    )
  )
}

pkg_file <- function(..., package = "mschuindt", mustWork = FALSE) {
  if (devtools_loaded(package)) {
    # used only if package has been loaded with devtools or pkgload
    file.path(find.package(package), "inst", ...)
  } else {
    system.file(..., package = package, mustWork = mustWork)
  }
}

devtools_loaded <- function(x) {
  if (!x %in% loadedNamespaces()) {
    return(FALSE)
  }
  ns <- .getNamespace(x)
  !is.null(ns$.__DEVTOOLS__)
}
