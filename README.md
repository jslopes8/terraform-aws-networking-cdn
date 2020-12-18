# Terraform Module AWS CloudFront (CDN)

Terraform module irá provisionar os seguintes recursos:

* [CloudFront](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution)
* [CloudFront Public Key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_public_key)

Para o recursos [Cloudfront OAI](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_identity), se a implantação requerer o S3 Origin, você deverá seguir com a construção deste recursos, seguido do argumento `s3_origin_config` no bloco `origin_settings`.

## Usage
```hcl
module "deploy_cdn" {
    source = "git@github.com:jslopes8/terraform-aws-networking-cdn.git?ref=v0.1.2"

    origin_settings = [{
        domain_name             = "${local.s3_origin_id}.s3.amazonaws.com"
        origin_id               = local.s3_origin_id

        s3_origin_config  = {
          origin_access_identity  = aws_cloudfront_origin_access_identity.main.cloudfront_access_identity_path
        }
    }]

    enabled             = "true"
    comment             = local.comment
    default_root_object = "index.html"
    price_class         = "PriceClass_All"
    #aliases             = [ "cdn-s3-test" ]

    default_cache_behavior_settings = [
        {
            target_origin_id = local.s3_origin_id

            viewer_protocol_policy  = "redirect-to-https"
            min_ttl                 = "86400" 
            default_ttl             = "604800"
            max_ttl                 = "31536000"

            allowed_methods = [ "GET", "HEAD", "OPTIONS" ]
            cached_methods  = [ "GET", "HEAD", "OPTIONS" ]
            
            forwarded_values = {
                query_string = "false"
                headers = [
                    "Origin", 
                    "Access-Control-Request-Method",
                    "Access-Control-Request-Headers"
                ]
                cookies = {
                    forward = "none"
                }
            }
        }
    ]

    restrictions = [{
        geo_restriction = {
            restriction_type    = "none"
        }
    }]

    viewer_certificate = [{
        cloudfront_default_certificate = "true"
    }]

    default_tags = {
      Environment = "SandBonx"
      Squad       = "TeamA"
    }
}
```

## Requirements
| Name | Version |
| ---- | ------- |
| aws | ~> 3.18 |
| terraform | ~> 0.13 |

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Variables Inputs
| Name | Description | Required | Type | Default |
| ---- | ----------- | -------- | ---- | ------- |
| origin_settings | Bloco que argumento para configuração do Origin. Permite um ou mais blocos. | `yes` | `list` | `[]` |
| enabled | Se a distribuição está habilitada para aceitar solicitações de conteúdo do usuário final. | `yes` | `bool` | `true` |
| comment | Comentários que você deseja incluir sobre a distribuição. | `yes` | `string` | ` ` |
| default_root_object | O objeto que você deseja que o CloudFront retorne (por exemplo, index.html) quando um usuário final solicita o root da URL. | `no` | `string` | `null` |
| price_class | A classe de preço para esta distribuição. Valores validos `PriceClass_All`, `PriceClass_200`, `PriceClass_100`. | `no` | `string` | `null` |
| aliases | CNAMEs (nomes de domínio alternativos), se houver, para esta distribuição. | `no` | `list` | `[]` |
| is_ipv6_enabled | Se deseja habilitar IPv6 para sua distribuição. | `no` | `bool` | `true` |
| web_acl_id | Associar um AWS WAF Web ACL v2 use o ACL ARN. | `no` | `string` | `null` |
| retain_on_delete | Desativa a distribuição em vez de excluí-lo ao destruir o recurso por meio do Terraform. | `no` | `bool` | `false` |
| default_cache_behavior_settings | Uma lista de recuros de comportamentos de cache padrão para esta distribuição (máximo um). | `yes` | `list` | `[]` |
| ordered_cache_behavior | Uma lista ordenada de recursos de comportamentos de cache para esta distribuição. | `no` | `list` | `[]` |
| restrictions | Uma lista de configuração de restrição para esta distribuição (máximo um). | `yes` | `list` | `[]` |
| viewer_certificate | Uma configuração de SSL para esta distribuição (máximo um). | `yes` | `list` | `[]` |
| logging_config | Uma configuração de registro que controla como os registros são gravados em sua distribuição (no máximo um). | `no` | `list` | `[]` |
| default_tags | Block de chave-valor que fornece o taggeamento para todos os recursos criados. | `no` | `map` | `{}` |
| public_key | Uma configuração para criar uma chave pública para sua distribuição. |  `no` | `list` | `[]` |

## Variable Outputs
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
| Name | Description |
| ---- | ----------- |
| domain_name | O nome de domínio correspondente à distribuição. |