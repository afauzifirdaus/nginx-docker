pipeline {
  agent any
  options { timestamps() }
  parameters {
    choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Pilih aksi Terraform')
    string(name: 'PESAN', defaultValue: 'Halo dari Terraform + Jenkins', description: 'Teks di halaman web')
  }
  environment {
    TF_VAR_pesan = "${params.PESAN}"
    TF_IN_AUTOMATION = 'true'
  }
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }
    stage('Format') {
      steps { sh 'terraform -chdir=terraform fmt -check -diff' }
    }
    stage('Init') {
      steps { sh 'terraform -chdir=terraform init -input=false' }
    }
    stage('Validate') {
      steps { sh 'terraform -chdir=terraform validate' }
    }
    stage('Plan') {
      steps {
        script {
          def flag = params.ACTION == 'destroy' ? '-destroy' : ''
          sh "terraform -chdir=terraform plan -input=false ${flag} -out=tfplan"
        }
      }
    }
    stage('Approve') {
      steps { input message: "Lanjut ${params.ACTION}?" }
    }
    stage('Apply') {
      steps { sh 'terraform -chdir=terraform apply -input=false tfplan' }
    }
  }
  post {
    success {
      script {
        if (params.ACTION == 'apply') {
          sh 'terraform -chdir=terraform output url'
        }
      }
    }
  }
}
