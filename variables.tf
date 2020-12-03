variable "create_cdn" {
    type    = bool
    default = true
}
variable "enabled" {
    type    = bool
    default = true
}
variable "is_ipv6_enabled" {
    type    = bool
    default = true
}
variable "comment" {
    type = string
    default = null
}
variable "default_root_object" {
    type = string
    default = null    
}
variable "aliases" {
    type = list
    default = []
}
variable "price_class" {
    type = string
    default = null
}
variable "web_acl_id" {
    type = string
    default = null
}
variable "retain_on_delete" {
    type = string
    default = null
}
variable "origin_settings" {
    type = any
    default = []
}
variable "logging_config" {
    type = any
    default = []
}
variable "default_cache_behavior_settings" {
    type = any
    default = []
}
variable "ordered_cache_behavior" {
    type = any
    default = []
}
variable "restrictions" {
    type = any
    default = []
}
variable "viewer_certificate" {
    type = any
    default = []
}
variable "default_tags" {
    type = map(string)
    default = {}
}
variable "public_key" {
    type = any
    default = []   
}
variable "trusted_signers" {
    type = list
    default = []   
}