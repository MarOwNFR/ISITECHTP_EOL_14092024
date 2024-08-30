provider "vsphere" {
  user             = "g03@vsphere.local"
  password         = "P@ssw0rd2024"
  vsphere_server   = "172.16.200.212"

  # Si vous avez un certificat SSL invalide
  allow_unverified_ssl = true
}

# Récupérer le datacenter avec le nom exact
data "vsphere_datacenter" "dc" {
  name = "Datacenter"  # Nom du datacenter
}

# Récupérer le datastore
data "vsphere_datastore" "datastore" {
  name          = "NFS01"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Récupérer le réseau
data "vsphere_network" "network" {
  name          = "C1-GR3-LAN1"  # Nom du réseau spécifique
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Récupérer le pool de ressources
data "vsphere_resource_pool" "pool" {
  name          = "172.16.103.248/Resources/GR3"  # Nom du pool de ressources
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Récupérer le dossier avec le chemin complet
data "vsphere_folder" "folder" {
  path = "Datacenter/vm/ESXI 1/Formateurs/Abderaman"  # Chemin du dossier correct
}

# Exemple de ressource de machine virtuelle (VM)
resource "vsphere_virtual_machine" "vm" {
  name             = "VM Tarraforme [ GR3 ]"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = data.vsphere_folder.folder.id  # Spécifier le dossier avec ID correct

  num_cpus = 2
  memory   = 4096
  guest_id = "otherGuest"  # Choisissez l'ID d'invité approprié

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label            = "disk0"
    size             = 20
    eagerly_scrub    = false
    thin_provisioned = true
  }
}
