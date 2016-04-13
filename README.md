Introduction
============

This project is aimed to help you understand routing, IPSec, packet filtering and networking in general.

Requirements
============

* Virtualbox https://www.virtualbox.org/wiki/Downloads
* Vagrant https://www.vagrantup.com/downloads.html
* git https://git-scm.com/downloads
* ruby 2.x https://www.ruby-lang.org/en/downloads/
* bundler http://bundler.io/

The Network
===========

    +----------------+
    |                |
    |   client_jp    |
    |                |
    +-------+--------+
            | 192.168.101.10/24
            |
            | 192.168.101.254/24
    +-------+--------+
    |                |
    |      gw_jp     |
    |                |
    +-------+--------+
            | 172.16.1.10/24
            |
            | 172.16.1.254/24
    +-------+--------+
    |                |
    |     router     | (do not configure this VM)
    |                |
    +-------+--------+
            | 172.16.2.254/24
            |
            | 172.16.2.10/24
    +-------+--------+
    |                |
    |      gw_uk     |
    |                |
    +-------+--------+
            | 192.168.102.254/24
            |
            | 192.168.102.10/24
    +-------+--------+
    |                |
    |   client_uk    |
    |                |
    +----------------+

Preparing
=========

    > git clone git@github.com:reallyenglish/ansible-project-networking-example.git
    > cd ansible-project-networking-example

Installing gems
---------------

    > bundle install --path vendor/bundle

Running instances
-----------------

    > vagrant up
    ...

    > vagrant status
    Current machine states:

    client_jp                 running (virtualbox)
    gw_jp                     running (virtualbox)
    router                    running (virtualbox)
    gw_uk                     running (virtualbox)
    client_uk                 running (virtualbox)

    This environment represents multiple VMs. The VMs are all listed
    above with their current state. For more information about a specific
    VM, run `vagrant status NAME`.

Checking all tests pass
-----------------------

    > bundle exec rake spec

Logging in
----------

    > vagrant ssh $HOSTNAME

Destroying VMs
--------------

If you want to start from scratch, run:

    > vagrant destroy

then,

    > vagrant up

References
----------

For OpenBSD, see:

* The FAQ http://www.openbsd.org/faq/index.html
* FAQ 6 - Networking http://www.openbsd.org/faq/faq6.html

For TCP/IP, see:

* The TCP/IP Guide http://www.tcpipguide.com/

Tasks
=====

Create your own branch.

    > git branch mybranch
    > git checkout mybranch

Complete the following tasks.

Task 1
------

Make sure:

* client\_jp can reach to gw\_jp
* client\_jp can NOT reach to gw\_uk
* gw\_jp can reach to gw\_uk
* gw\_jp can NOT reach to client\_uk

Task 2
------

Configure gw\_jp to NAT packets from 192.168.101.0/24 to 172.16.0.0/16. Make sure client\_jp can reach to gw\_uk. Configure the same settings on gw\_uk. The both clients should be able to reach the gateways.

Task 3
------

Create test cases that cover all the tasks. See how to write tests at:

* https://github.com/otahi/infrataster-plugin-firewall
* https://github.com/ryotarai/infrataster

Make sure tests pass.

    > bundle exec rake spec

    Finished in 8.02 seconds (files took 6.69 seconds to load)
    6 examples, 0 failures

Task 4
------

Create IPSec VPN (IKE v1) tunnel.

| parameter name | value       |
|----------------|-------------|
| encapsulation        | main mode, ESP tunnel |
| src and dest address | (see ifconfig egress) |
| phase 1 crypt        | HMAC SHA1, AES 128 bit |
| phase 2 crypt        | HMAC SHA1, AES 128 bit |
| preshared key        | mypassword |
| src and dest address | 172.16.1.10 and 172.16.2.10 |

Make sure you can ping from gw1.jp to gw2.jp.

Make sure ICMP packets are encrypted by running tcpdump(8).

Task 5
------

Create and enable enc(4) virtual interface.

Make sure you can see unencrypted ICMP packets by `tcpdump -ni enc0`.

Task 6
------

Create gre(4) tunnel.

| parameter name | value |
|----------------|-------|
| outer tunnel addresses | 172.16.1.10 (gw1.jp) and 172.16.2.10 (gw1.uk) | 
| inner addresses | 192.168.255.1/30 (gw1.jp) and 192.168.255.2/30 (gw1.uk) |
| operation mode | IPPROTO\_GRE |

Make sure you can ping 172.16.2.10 on gw1.jp.

Make sure GRE packets are encrypted by `tcpdump`.
