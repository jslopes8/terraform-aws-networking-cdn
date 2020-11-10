#resource "aws_cloudfront_origin_access_identity" "main" {
#    count = var.create_cdn ? 1 : 0
#
#    comment = var.comment
#}
resource "aws_cloudfront_distribution" "main" {
    count = var.create_cdn ? 1 : 0

    enabled             = var.enabled
    is_ipv6_enabled     = var.is_ipv6_enabled
    comment             = var.comment
    default_root_object = var.default_root_object
    aliases             = var.aliases
    web_acl_id          = var.web_acl_id
    retain_on_delete    = var.retain_on_delete
    price_class         = var.price_class

    # One or more origins for this distribution (multiples allowed).
    dynamic "origin" {
        for_each = var.origin_settings

        content {
            domain_name = lookup(origin.value, "domain_name", null)
            origin_id   = lookup(origin.value, "origin_id", null)
            s3_origin_config {
                origin_access_identity = lookup(origin.value, "origin_access_identity", null)
            }
        }
    }

    dynamic "default_cache_behavior" {
        for_each = var.default_cache_behavior_settings

        content {
            allowed_methods         = lookup(default_cache_behavior.value, "allowed_methods", null)
            cached_methods          = lookup(default_cache_behavior.value, "cached_methods", null)
            target_origin_id        = lookup(default_cache_behavior.value, "target_origin_id", null)
            viewer_protocol_policy  = lookup(default_cache_behavior.value, "viewer_protocol_policy", null)
            min_ttl                 = lookup(default_cache_behavior.value, "min_ttl", null)
            default_ttl             = lookup(default_cache_behavior.value, "default_ttl", null)
            max_ttl                 = lookup(default_cache_behavior.value, "max_ttl", null)

            dynamic "forwarded_values" {
                for_each = length(keys(lookup(default_cache_behavior.value, "forwarded_values", {}))) == 0 ? [] : [lookup(default_cache_behavior.value, "forwarded_values", {})]
                
                content {
                    query_string = lookup(forwarded_values.value, "query_string", null)

                    dynamic "cookies" {
                        for_each = length(keys(lookup(forwarded_values.value, "cookies", {}))) == 0 ? [] : [lookup(forwarded_values.value, "cookies", {})]

                        content {
                            forward = lookup(cookies.value, "forward", null)
                        }
                    }
                }
            }
        }
    }

    dynamic "ordered_cache_behavior" {
        for_each = var.ordered_cache_behavior

        content {
            path_pattern            = lookup(ordered_cache_behavior.value, "path_pattern", null)
            allowed_methods         = lookup(ordered_cache_behavior.value, "allowed_methods", null)
            cached_methods          = lookup(ordered_cache_behavior.value, "cached_methods", null)
            target_origin_id        = lookup(ordered_cache_behavior.value, "target_origin_id", null)
            min_ttl                 = lookup(ordered_cache_behavior.value, "min_ttl", null)
            default_ttl             = lookup(ordered_cache_behavior.value, "default_ttl", null)
            max_ttl                 = lookup(ordered_cache_behavior.value, "max_ttl", null)
            compress                = lookup(ordered_cache_behavior.value, "compress", null)
            viewer_protocol_policy  = lookup(ordered_cache_behavior.value, "viewer_protocol_policy", null)

            dynamic "forwarded_values" {
                for_each = length(keys(lookup(ordered_cache_behavior.value, "forwarded_values", {}))) == 0 ? [] : [lookup(ordered_cache_behavior.value, "forwarded_values", {})]

                content {
                    query_string    = lookup(forwarded_values.value, "query_string", null)
                    headers         = lookup(forwarded_values.value, "headers", null)

                    dynamic "cookies" {
                        for_each = length(keys(lookup(forwarded_values.value, "cookies", {}))) == 0 ? [] : [lookup(forwarded_values.value, "cookies", {})]

                        content {
                            forward = lookup(cookies.value, "forward", null)
                        }
                    }
                }
            }
        }
    }

    dynamic "restrictions" {
        for_each = var.restrictions
        content {
            dynamic "geo_restriction" {
                for_each = length(keys(lookup(restrictions.value, "geo_restriction", {}))) == 0 ? [] : [lookup(restrictions.value, "geo_restriction", {})]
                content {
                    restriction_type    = lookup(geo_restriction.value, "restriction_type", null)
                    locations           = lookup(geo_restriction.value, "locations", null)
                }
            }
        }
    } 

    dynamic "viewer_certificate" {
        for_each = var.viewer_certificate
        content {
            cloudfront_default_certificate  = lookup(viewer_certificate.value, "cloudfront_default_certificate", null)
            acm_certificate_arn             = lookup(viewer_certificate.value, "acm_certificate_arn", null)
            minimum_protocol_version        = lookup(viewer_certificate.value, "minimum_protocol_version", null)
            ssl_support_method              = lookup(viewer_certificate.value, "ssl_support_method", null)
        }
    }

    # The logging configuration that controls how logs are written to your distribution (maximum one).
    dynamic "logging_config" {
        for_each = var.logging_config
        content {
            include_cookies = lookup(logging_config.value, "include_cookies", null)
            bucket          = lookup(logging_config.value, "bucket", null)
            prefix          = lookup(logging_config.value, "prefix", null)
        }
    }

    tags = var.default_tags
}   
