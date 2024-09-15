data "http" "my_ip" {
  url = "http://ipinfo.io/ip"
}

# Webサーバー用のパケットフィルタリング
resource "sakuracloud_packet_filter" "web" {
  name        = "${var.service}-${var.env}-web-filter"
  description = "packet filter for web"
}

resource "sakuracloud_packet_filter_rules" "web" {
  packet_filter_id = sakuracloud_packet_filter.web.id

  # terraform実行者のみがansible実行用にSSHポートをオープンする
  expression {
    protocol         = "tcp"
    destination_port = "22"
    source_network   = trim(data.http.my_ip.response_body, " ")
    description      = "execute port of ansible"
  }

  # Web application用ポート
  expression {
    protocol         = "tcp"
    destination_port = "8080"
    description      = "web application port"
  }

  expression {
    protocol         = "tcp"
    destination_port = "32768-61000"
  }

  expression {
    protocol         = "udp"
    destination_port = "32768-61000"
  }

  expression {
    protocol = "icmp"
  }

  # フラグメントはすべて許可する
  expression {
    protocol = "fragment"
  }

  expression {
    protocol    = "ip"
    allow       = false
    description = "Deny ALL"
  }
}

# DBサーバー用のパケットフィルタリング
resource "sakuracloud_packet_filter" "db" {
  name        = "${var.service}-${var.env}-db-filter"
  description = "packet filter for database server"
}

resource "sakuracloud_packet_filter_rules" "db" {
  packet_filter_id = sakuracloud_packet_filter.db.id

  # terraform実行者のみがansible実行用にSSHポートをオープンする
  expression {
    protocol         = "tcp"
    destination_port = "22"
    source_network   = trim(data.http.my_ip.response_body, " ")
    description      = "execute port of ansible"
  }

  # Postgresql server用ポート
  expression {
    protocol         = "tcp"
    destination_port = "5432"
    source_network   = trim(data.http.my_ip.response_body, " ")
    description      = "postresql port"
    ## TODO 同じセグメントのみでのIPを許可するように修正
  }

  expression {
    protocol         = "tcp"
    destination_port = "32768-61000"
  }

  expression {
    protocol         = "udp"
    destination_port = "32768-61000"
  }

  expression {
    protocol = "icmp"
  }

  # フラグメントはすべて許可する
  expression {
    protocol = "fragment"
  }

  expression {
    protocol    = "ip"
    allow       = false
    description = "Deny ALL"
  }
}


# Managementサーバー用のパケットフィルタリング
resource "sakuracloud_packet_filter" "mng" {
  name        = "${var.service}-${var.env}-mng-filter"
  description = "packet filter for management server"
}

resource "sakuracloud_packet_filter_rules" "mng" {
  packet_filter_id = sakuracloud_packet_filter.mng.id

  # terraform実行者のみがansible実行用にSSHポートをオープンする
  expression {
    protocol         = "tcp"
    destination_port = "22"
    source_network   = trim(data.http.my_ip.response_body, " ")
    description      = "execute port of ansible"
  }

  # Management server用ポート
  expression {
    protocol         = "tcp"
    destination_port = "443"
    description      = "web application port"
  }


  expression {
    protocol         = "tcp"
    destination_port = "32768-61000"
  }

  expression {
    protocol         = "udp"
    destination_port = "32768-61000"
  }

  expression {
    protocol = "icmp"
  }

  # フラグメントはすべて許可する
  expression {
    protocol = "fragment"
  }

  expression {
    protocol    = "ip"
    allow       = false
    description = "Deny ALL"
  }
}