module "review-namespace" {
  source = "../modules/namespace"

  name   = "review-${local.formated_target}"
  domain = "review"

  admins  = var.namepsace_admins
  editors = var.namepsace_editors
  readers = var.namepsace_readers
}
