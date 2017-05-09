# Terraform Modules

This repo contains some modules that I've created for terraform.  They should generally
be generic and usable across multiple projects.
 
## Modules


### named_ec2_instance

Useful for creating a managed (named) ec2 instance.  That is, one that will be managed
over time, with some personality (not a drone in an autoscaling group).

The module creates an instance, and adds a record to DNS for it.