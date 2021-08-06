terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "netascode/aci"
      version = ">=0.2.0"
    }
  }
}

resource "aci_rest" "infraFexP" {
  dn         = "uni/infra/fexprof-FEX101"
  class_name = "infraFexP"
}

module "main" {
  source = "../.."

  interface_profile = aci_rest.infraFexP.content.name
  name              = "1-1"
}

data "aci_rest" "infraHPortS" {
  dn = "uni/infra/fexprof-FEX101/hports-${module.main.name}-typ-range"

  depends_on = [module.main]
}

resource "test_assertions" "infraHPortS" {
  component = "infraHPortS"

  equal "name" {
    description = "name"
    got         = data.aci_rest.infraHPortS.content.name
    want        = module.main.name
  }
}
