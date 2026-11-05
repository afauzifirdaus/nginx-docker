# Ambil binary Terraform dari image resmi (otomatis cocok amd64/arm64)
ARG TERRAFORM_VERSION=1.14
FROM hashicorp/terraform:${TERRAFORM_VERSION} AS tf

FROM jenkins/jenkins:lts-jdk21
COPY --from=tf /bin/terraform /usr/local/bin/terraform
