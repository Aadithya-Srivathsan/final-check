variable "location" {
  type        = string
  description = "Azure region"
  default     = "westeurope"
}

variable "project_name" {
  type        = string
  description = "Project short name used in resource names"
  default     = "genaifunction"
}

variable "azure_openai_endpoint" {
  type        = string
  description = "Azure OpenAI endpoint (https://xxxx.openai.azure.com)"
}

variable "azure_openai_api_key" {
  type        = string
  description = "Azure OpenAI API key"
  sensitive   = true
}

variable "azure_openai_deployment" {
  type        = string
  description = "Azure OpenAI deployment name (model deployment)"
}

variable "azure_openai_api_version" {
  type        = string
  description = "Azure OpenAI API version"
  default     = "2025-03-01-preview"
}

variable "function_identity_object_id" {
  type        = string
  description = "Object ID of the existing Function App's managed identity"
  default     = "b5c8b279-4e5b-4dfd-9a5d-c7ad2d1a73aa"
}
