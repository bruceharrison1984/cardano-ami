locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "ubuntu" {
  ami_name        = "cardano-node-${local.timestamp}"
  ami_description = "Provisioned AMI for running a Cardano cluster"
  instance_type   = "m5.4xlarge"
  region          = "us-east-1"
  ena_support     = true
  ssh_username    = "ubuntu"
  encrypt_boot    = true
  ebs_optimized   = true

  launch_block_device_mappings {
    device_name = "/dev/sda1"
    volume_size = 100
    encrypted = true
  }
  
  ## use offical Ubuntu AMI to start
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }

  tags = {
    Name         = "cardano-node-${local.timestamp}"
    CreatedOn    = timestamp()
    ENA          = true
    EBSOptimized = true
    Encrypted    = true
  }
}

build {
  sources = ["source.amazon-ebs.ubuntu"]
  provisioner "shell" {
    inline = ["mkdir /home/ubuntu/setup_scripts/"]
  }
  provisioner "file" {
    destination = "/home/ubuntu/setup_scripts/"
    source      = "./scripts/"
  }
  provisioner "shell" {
    inline = [
      "chmod -R +x ~/setup_scripts/*.sh",
      "~/setup_scripts/init.sh",
      "/setup_scripts/cabal.sh",
      "/setup_scripts/libsodium.sh"
    ]
  }
}
