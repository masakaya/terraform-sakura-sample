resource "sakuracloud_proxylb" "main" {
  name           = "${var.service}-${var.env}-proxylb"
  plan           = 500
  vip_failover   = true  # default: false
  sticky_session = false # ラウンドロビンで動作させるため、sessionによる経路固定は指定
  gzip           = true  # 圧縮
  proxy_protocol = true
  region         = var.lb_region

  health_check {
    protocol   = "tcp"
    delay_loop = 10
  }

  bind_port {
    proxy_mode        = "http"
    port              = 80
    redirect_to_https = true
  }

  bind_port {
    proxy_mode = "https"
    port       = 443
  }

  #syslog
  syslog {
    server = module.server["mng"].ip_address
    port   = 514
  }

  # Webサーバー 
  dynamic "server" {
    for_each = range(local.scale_server.server_count)
    content {
      ip_address = module.scale_server[server.value].ip_address
      port       = 80
      group      = "group1"
    }
  }
  rule {
    host  = "www.${var.domain}"
    path  = "/*"
    group = "group1"
  }

  # 管理サーバー
  server {
    ip_address = module.server["mng"].ip_address
    port       = 80
    group      = "group2"
  }
  rule {
    host       = "mng.${var.domain}"
    path       = "/*"
    group      = "group2"
    source_ips = join(",", var.allow_access_manage_server_ips)
  }

  certificate {
    server_cert       = module.acme.certificate_pem
    private_key       = module.acme.private_key_pem
    intermediate_cert = module.acme.issuer_pem
  }

}

