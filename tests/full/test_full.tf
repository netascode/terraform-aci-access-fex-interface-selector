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
  name              = "1-2"
  policy_group_type = "access"
  policy_group      = "ACC1"
  port_blocks = [{
    name        = "PB1"
    description = "My Description"
    from_port   = 1
    to_port     = 2
  }]
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

  equal "type" {
    description = "type"
    got         = data.aci_rest.infraHPortS.content.type
    want        = "range"
  }
}

data "aci_rest" "infraRsAccBaseGrp" {
  dn = "${data.aci_rest.infraHPortS.id}/rsaccBaseGrp"

  depends_on = [module.main]
}

resource "test_assertions" "infraRsAccBaseGrp" {
  component = "infraRsAccBaseGrp"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest.infraRsAccBaseGrp.content.tDn
    want        = "uni/infra/funcprof/accportgrp-ACC1"
  }
}

data "aci_rest" "infraPortBlk" {
  dn = "${data.aci_rest.infraHPortS.id}/portblk-PB1"

  depends_on = [module.main]
}

resource "test_assertions" "infraPortBlk" {
  component = "infraPortBlk"

  equal "name" {
    description = "name"
    got         = data.aci_rest.infraPortBlk.content.name
    want        = "PB1"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest.infraPortBlk.content.descr
    want        = "My Description"
  }

  equal "fromCard" {
    description = "fromCard"
    got         = data.aci_rest.infraPortBlk.content.fromCard
    want        = "1"
  }

  equal "toCard" {
    description = "toCard"
    got         = data.aci_rest.infraPortBlk.content.toCard
    want        = "1"
  }

  equal "fromPort" {
    description = "fromPort"
    got         = data.aci_rest.infraPortBlk.content.fromPort
    want        = "1"
  }

  equal "toPort" {
    description = "toPort"
    got         = data.aci_rest.infraPortBlk.content.toPort
    want        = "2"
  }
}
