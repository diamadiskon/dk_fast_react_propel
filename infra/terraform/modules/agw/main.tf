resource "azurerm_public_ip" "pip-agw" {
  name                = "pip-agw-${var.workload}-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}





resource "azurerm_application_gateway" "agw" {
  name                = "agw-${var.workload}-${var.environment}-${var.location_abbreviation}-001"
  resource_group_name = var.resource_group_name
  location            = var.location


  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }
  waf_configuration {
    enabled          = true
    rule_set_version = "3.2"
    firewall_mode    = "Detection"
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = var.subnet_agw
  }

  frontend_port {
    name = "frontend_port_name"
    port = 443
  }

  frontend_ip_configuration {
    name                 = "pip-agw-ip-name"
    public_ip_address_id = azurerm_public_ip.pip-agw.id
  }

  backend_address_pool {
    name  = "backend_address_pool"
    fqdns = [var.url]
  }

  backend_http_settings {
    name                                = "backend_http_settings"
    cookie_based_affinity               = "Disabled"
    pick_host_name_from_backend_address = true
    path                                = "/"
    port                                = 443
    protocol                            = "Https"
    request_timeout                     = 60
    probe_name                          = "probe"
  }

  # HTTPS Listener - Port 443  
  http_listener {
    name                           = "listener-443"
    frontend_ip_configuration_name = "pip-agw-ip-name"
    frontend_port_name             = "frontend_port_name"
    protocol                       = "Https"
    ssl_certificate_name           = var.certificate_name
  }

  request_routing_rule {
    name                       = "routing-rules"
    priority                   = 9
    rule_type                  = "Basic"
    http_listener_name         = "listener-443"
    backend_address_pool_name  = "backend_address_pool"
    backend_http_settings_name = "backend_http_settings"
  }


  ssl_certificate {
    name                = var.certificate_name
    key_vault_secret_id = var.my_cert_1_secret_id
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [var.appagumid]
  }


  probe {
    name                                      = "probe"
    pick_host_name_from_backend_http_settings = true
    path                                      = "/"
    protocol                                  = "Https"
    interval                                  = 30
    timeout                                   = 30
    unhealthy_threshold                       = 3
  }

}

resource "azurerm_web_application_firewall_policy" "zscaler-waf-policy" {
  name                = "waf-policy-prod-001"
  resource_group_name = var.resource_group_name
  location            = var.location

  custom_rules {
    name      = "zscalerallowlist"
    priority  = 1
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RemoteAddr"
      }

      operator           = "IPMatch"
      negation_condition = false
      match_values       = ["147.161.172.0/23", "170.85.78.0/23", "147.161.132.0/23", "185.46.212.0/23", "165.225.240.0/23", "147.161.148.0/23", "165.225.12.0/23", "147.161.154.0/23", "165.225.194.0/23", "136.226.170.0/23", "136.226.172.0/23", "147.161.226.0/23", "147.161.228.0/23", "147.161.230.0/23", "147.161.234.0/23", "165.225.72.0/22", "147.161.164.0/23", "147.161.254.0/23", "165.225.26.0/23", "136.226.164.0/23", "136.226.162.0/23", "147.161.134.0/23", "147.161.136.0/23", "147.161.138.0/23", "147.161.186.0/23", "147.161.224.0/23", "165.225.80.0/22", "147.161.166.0/23", "170.85.58.0/23", "136.226.166.0/23", "136.226.168.0/23", "147.161.140.0/23", "147.161.142.0/23", "147.161.144.0/23", "147.161.190.0/23", "165.225.92.0/23", "147.161.236.0/23", "136.226.190.0/23", "165.225.196.0/23", "165.225.198.0/23", "147.161.178.0/23", "147.161.180.0/23", "147.161.182.0/23", "147.161.244.0/23", "136.226.186.0/23", "136.226.188.0/23", "170.85.30.0/23", "165.225.202.0/23", "165.225.90.0/23", "147.161.176.0/23", "170.85.2.0/23", "170.85.4.0/23", "147.161.250.0/23", "147.161.168.0/23", "147.161.170.0/23", "147.161.146.0/23"]


    }

    action = "Allow"
  }
  policy_settings {
    enabled                     = true
    mode                        = "Prevention"
    request_body_check          = true
    file_upload_limit_in_mb     = 100
    max_request_body_size_in_kb = 128
  }

  managed_rules {
    exclusion {
      match_variable          = "RequestHeaderNames"
      selector                = "x-company-secret-header"
      selector_match_operator = "Equals"
    }
    exclusion {
      match_variable          = "RequestCookieNames"
      selector                = "too-tasty"
      selector_match_operator = "EndsWith"
    }

    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
      rule_group_override {
        rule_group_name = "REQUEST-920-PROTOCOL-ENFORCEMENT"
        rule {
          id      = "920300"
          enabled = true
          action  = "Log"
        }

        rule {
          id      = "920440"
          enabled = true
          action  = "Block"
        }
      }
    }
  }
  depends_on = [azurerm_application_gateway.agw]
}


