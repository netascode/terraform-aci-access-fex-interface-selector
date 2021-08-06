output "dn" {
  value       = aci_rest.infraHPortS.id
  description = "Distinguished name of `infraHPortS` object."
}

output "name" {
  value       = aci_rest.infraHPortS.content.name
  description = "FEX interface selector name."
}
