# Vagrantfile
Vagrant.configure("2") do |config|
  config.ssh.shell = "/bin/sh"
  config.vm.provider "virtualbox" do |v|
    v.memory = 256
    v.cpus = 1
  end
  config.vm.box = "trombik/ansible-openbsd-5.8-amd64"
  config.vm.box_check_update = false

  config.vm.define :client_jp do |c|
    c.vm.network "private_network", ip: "192.168.101.10", virtualbox__intnet: "intranet_japan"
    # vagrant instances has a NAT network, which is the default route. add
    # static routes to all the private networks.
    #
    # hostname.if(5) is the place to add static routes. however, vagrant
    # overrides hostname.if(5) when configuring interfaces. add the commands to
    # rc.local instead.
    c.vm.provision "shell", inline: <<-SHELL
route add 172.16.0.0/16 192.168.101.254
route add 192.168.0.0/16 192.168.101.254
echo route add 172.16.0.0/16 192.168.101.254 >> /etc/rc.local
echo route add 192.168.0.0/16 192.168.101.254 >> /etc/rc.local
SHELL
  end

  config.vm.define :gw_jp do |c|
    c.vm.network "private_network", ip: "192.168.101.254", virtualbox__intnet: "intranet_japan"
    c.vm.network "private_network", ip: "172.16.1.10", virtualbox__intnet: "japan"
    c.vm.provision "shell", inline: <<-SHELL
route add 172.16.0.0/16 172.16.1.254
route add 192.168.0.0/16 172.16.1.254
echo route add 172.16.0.0/16 172.16.1.254 >> /etc/rc.local
echo route add 192.168.0.0/16 172.16.1.254 >> /etc/rc.local
SHELL
  end

  config.vm.define :router do |c|
    c.vm.network "private_network", ip: "172.16.1.254", virtualbox__intnet: "japan"
    c.vm.network "private_network", ip: "172.16.2.254", virtualbox__intnet: "uk"
    # enable ipv4 routing
    #
    # null-route 192.168/16 so that it naver routes packets to the network.
    c.vm.provision "shell", inline: <<-SHELL
sysctl net.inet.ip.forwarding=1
echo net.inet.ip.forwarding=1 >> /etc/sysctl.conf
route add 192.168.0.0/16 127.0.0.1
echo route add 192.168.0.0/16 127.0.0.1 >> /etc/rc.local
SHELL
  end

  config.vm.define :gw_uk do |c|
    c.vm.network "private_network", ip: "192.168.102.254", virtualbox__intnet: "intranet_uk"
    c.vm.network "private_network", ip: "172.16.2.10", virtualbox__intnet: "uk"
    c.vm.provision "shell", inline: <<-SHELL
route add 172.16.0.0/16 172.16.2.254
route add 192.168.0.0/16 172.16.2.254
echo route add 172.16.0.0/16 172.16.2.254 >> /etc/rc.local
echo route add 192.168.0.0/16 172.16.2.254 >> /etc/rc.local
SHELL
  end

  config.vm.define :client_uk do |c|
    c.vm.network "private_network", ip: "192.168.102.10", virtualbox__intnet: "intranet_uk"
    c.vm.provision "shell", inline: <<-SHELL
route add 172.16.0.0/16 192.168.102.254
route add 192.168.0.0/16 192.168.102.254
echo route add 172.16.0.0/16 192.168.102.254 >> /etc/rc.local
echo route add 192.168.0.0/16 192.168.102.254 >> /etc/rc.local
SHELL
  end
end
