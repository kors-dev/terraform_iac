# terraform_iac

# Вкажи свій проект і регіон (приклад: europe-central2 — Варшава)
gcloud config set project ak-gke-lab-euc2
gcloud config set compute/region europe-central2

# Увімкнути потрібні API
gcloud services enable container.googleapis.com compute.googleapis.com

# Перевірити, що terraform встановлений
terraform -v

# У файлі main.tf додайте наступний блок коду для створення коду на базі модуля tf-google-gke-cluster:
module "gke_cluster" {
  source         = "github.com/<ВАШ-РЕПОЗИТОРІЙ>/tf-google-gke-cluster"
  GOOGLE_REGION  = var.GOOGLE_REGION
  GOOGLE_PROJECT = var.GOOGLE_PROJECT
  GKE_NUM_NODES  = 2
}

# variables.tf
variable "GOOGLE_PROJECT" {
  type        = string
  description = "gcp project name"
}

variable "GOOGLE_REGION" {
  type        = string
  default     = "us-central1-c"
  description = "gcp region for GKE"
}

variable "GKE_NUM_NODES" {
  type        = number
  description = "default number of gke nodes"
}


# vars.tfvars
GOOGLE_REGION  = "europe-central2"
GOOGLE_PROJECT = "<YOUR_GCP_PROJECT_ID>"
GKE_NUM_NODES  = 2

# Ініціалізація, формат, валідація
terraform init
terraform fmt -recursive
terraform validate

# Створити план
terraform plan -var-file=vars.tfvars -out=plan.out
terraform show -json plan.out > plan.json

# Infracost установка, налаштування і запуск
curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sh

infracost configure set api_key <YOUR_INFRACOST_API_KEY>

infracost breakdown --path plan.json --format table

![alt text](image-1.png)

# Розгортання інфраструктури

terraform apply -var-file=vars.tfvars

# Після успішного apply подивись стан/виходи:

 terraform show

 ![alt text](image.png)


# Знищення ресурсів після перевірки
terraform destroy -var-file=vars.tfvars

# У Google Cloud Console перейдіть до розділу Cloud Storage і створіть новий bucket для зберігання вашого стану Terraform.

# додати бакет до main.tf
terraform {
  backend "gcs" {
    bucket = "your-bucket-name"
    prefix = "terraform/state"
  }
}

# виконати ще раз ініціалізацію і підтвердити перенесення стану
terraform init

#Перевір, що state тепер у GCS
# Повинні з’явитись об’єкти типу .../default.tfstates/...
gsutil ls -r gs://your-bucket-name/terraform/state
# Локальний state-файл terraform.tfstate більше не потрібен


