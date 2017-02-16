data "template_file" "service" {
  template = "${file("${path.module}/templates/cloud-init.tpl")}"

  vars = {}
}
