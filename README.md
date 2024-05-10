# Module Terraform : Création automatique d'un client Windows

Ce module Terraform permet la création automatique d'un client Windows dans votre infrastructure cloud. Il peut être utilisé pour provisionner rapidement et facilement des clients Windows dans des environnements cloud tels que AWS, Azure, Google Cloud, etc.
Utilisation
Prérequis

Avant d'utiliser ce module, assurez-vous d'avoir les éléments suivants :

    Terraform installé localement. Vous pouvez trouver des instructions d'installation sur le site officiel de Terraform.
    Un compte dans le fournisseur cloud de votre choix (AWS, Azure, etc.).
    Les informations d'identification nécessaires pour vous connecter à votre compte cloud via Terraform.

Exemple d'utilisation

Voici un exemple d'utilisation de ce module dans un fichier Terraform :

hcl

module "client_windows" {
  source = "github.com/votre-utilisateur/module-client-windows"

  // Spécifiez ici les variables nécessaires au déploiement du client Windows
  // Par exemple :
  // client_name = "client-windows-1"
  // instance_type = "t2.micro" (pour AWS)
  // disk_size_gb = 30
  // ...
}

// Utilisez les sorties du module si nécessaire
output "client_windows_ip" {
  value = module.client_windows.client_ip
}

Variables disponibles

Ce module expose les variables suivantes :

    client_name : Le nom du client Windows à créer.
    instance_type : Le type d'instance à utiliser pour le client Windows (par exemple, t2.micro pour AWS).
    disk_size_gb : La taille du disque en gigaoctets pour le client Windows.
    ... (ajoutez d'autres variables selon les besoins)

Sorties disponibles

Ce module expose les sorties suivantes :

    client_ip : L'adresse IP du client Windows créé.

Exemple de déploiement

Une fois le fichier Terraform créé avec les configurations appropriées, vous pouvez déployer le client Windows en exécutant les commandes suivantes :

```sh

terraform init
terraform plan
terraform apply

```

Après avoir confirmé, Terraform commencera à provisionner les ressources nécessaires dans votre environnement cloud, y compris le client Windows.
Nettoyage

Après avoir terminé l'utilisation du client Windows, vous pouvez supprimer les ressources créées en exécutant la commande Terraform suivante :

```sh
terraform destroy
```
