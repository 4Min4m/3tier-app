provider "kubernetes" {
  config_path = "/root/.kube/config" # Killercoda's kubeconfig path
}

resource "kubernetes_namespace" "app" {
  metadata {
    name = "three-tier-app"
  }
}

resource "kubernetes_deployment" "database" {
  metadata {
    name      = "mysql"
    namespace = kubernetes_namespace.app.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "mysql"
      }
    }
    template {
      metadata {
        labels = {
          app = "mysql"
        }
      }
      spec {
        container {
          image = "amin4m/three-tier-database:latest"
          name  = "mysql"
          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value = "password"
          }
          env {
            name  = "MYSQL_DATABASE"
            value = "app_db"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "database" {
  metadata {
    name      = "mysql-service"
    namespace = kubernetes_namespace.app.metadata[0].name
  }
  spec {
    selector = {
      app = "mysql"
    }
    port {
      port        = 3306
      target_port = 3306
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_deployment" "backend" {
  metadata {
    name      = "backend"
    namespace = kubernetes_namespace.app.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "backend"
      }
    }
    template {
      metadata {
        labels = {
          app = "backend"
        }
      }
      spec {
        container {
          image = "amin4m/three-tier-backend:latest"
          name  = "backend"
          env {
            name  = "DB_HOST"
            value = "mysql-service"
          }
          env {
            name  = "DB_USER"
            value = "root"
          }
          env {
            name  = "DB_PASSWORD"
            value = "password"
          }
          env {
            name  = "DB_NAME"
            value = "app_db"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "backend" {
  metadata {
    name      = "backend-service"
    namespace = kubernetes_namespace.app.metadata[0].name
  }
  spec {
    selector = {
      app = "backend"
    }
    port {
      port        = 3000
      target_port = 3000
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_deployment" "frontend" {
  metadata {
    name      = "frontend"
    namespace = kubernetes_namespace.app.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "frontend"
      }
    }
    template {
      metadata {
        labels = {
          app = "frontend"
        }
      }
      spec {
        container {
          image = "amin4m/three-tier-frontend:latest"
          name  = "frontend"
        }
      }
    }
  }
}

resource "kubernetes_service" "frontend" {
  metadata {
    name      = "frontend-service"
    namespace = kubernetes_namespace.app.metadata[0].name
  }
  spec {
    selector = {
      app = "frontend"
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "NodePort"
  }
}