variable "domain" {
  type    = string
  default = "ppscan.org"
}

variable "subject_alternative_names" {
  type    = list(string)
  default = []
}

variable "ssl_reg_email_address" {
  type    = string
  default = "masashi.kayahara@arc-connects.com"
}

variable "password" {
  default   = "p@ssw0rd"
  type      = string
  sensitive = true
}

variable "default_region" {
  type        = string
  default     = "jp-north-1"
  description = "さくらのデフォルトリージョン"
}

variable "s3_endpoint" {
  type        = string
  default     = "https://s3.isk01.sakurastorage.jp"
  description = "さくらのS3バケットのリージョン(石狩第１)"
}

variable "service" {
  type        = string
  description = "サービス名"
  default     = "sample"
}

variable "env" {
  type        = string
  description = "環境名"
  default     = "prod"
}

variable "lb_region" {
  type        = string
  description = "デフォルトリージョン"
  default     = "is1" // 石狩リージョン
}

variable "default_zone" {
  type        = string
  description = "デフォルトゾーン"
  default     = "is1b" // 石狩第2ゾーン 
}

variable "api_key_id" {
  type        = string
  description = "オートスケール"
  default     = "113601543605" // APIキーの払い出しによって可変なため、tfval化を行うこと
}

variable "allow_access_manage_server_ips" {
  type        = list(string)
  description = "管理サーバーにアクセスを許可されたIPリスト"
  default     = ["175.129.201.94"]
}

variable "server_count" {
  type        = number
  description = "ウェブサーバーを何台保持するか？（最大で5台まで）"
  default     = 1
}
