require("neogen").setup {
    enabled = true,
    input_after_comment = true,
    languages = {
        cs = {
            template = {
                annotation_convention = "xmldoc",
            }
        }
    }
}
