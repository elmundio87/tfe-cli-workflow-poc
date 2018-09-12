variable loller {
  default = "test"
}

resource fake_resource "fake" {
  property = "value"
}

variable loller2 { description = "lul"}