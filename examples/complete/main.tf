module "aci_access_fex_interface_selector" {
  source = "netascode/access-fex-interface-selector/aci"

  interface_profile = "FEX101"
  name              = "1-1"
  policy_group_type = "access"
  policy_group      = "ACC1"
  port_blocks = [{
    name        = "PB1"
    description = "My Description"
    from_port   = 1
    to_port     = 2
  }]
}
