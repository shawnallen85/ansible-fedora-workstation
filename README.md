# ansible-fedora-workstation

A set of scripts and playbooks for maintaining consistent Fedora workstations.

## create-ansible-user.sh

Creates a user named ansible with a random password.

It assumes that a file, "ansible-user.pub", exists in your current working directory.

Below is an example of generating this file:

```bash
ssh-keygen -t rsa -b 4096 -C "ansible@example.com" -f ansible-user -q -N ""
```

That key will be used for configuring passwordless SSH logins.

This should be ran on all systems that will be maintained by Ansible.

This will also add a line to the `/etc/sudoers` file that allows for passwordless sudo.

You can access this user utilizing sudo:

```bash
sudo -u ansible -i
```

Get ansible-user.pub via web host on node:

```bash
curl https://example.org/ansible-user.pub -o ansible-user.pub
```

Copy ansible-user.pub via scp from host:

```bash
scp ansible-user.pub node:/home/${USER}
```

Once ansible-user.pub is on the node, run the following on the node:

```bash
curl -s https://raw.githubusercontent.com/shawnallen85/ansible-fedora-workstation/master/create-ansible-user.sh | sudo bash
```

## setup-ansible.sh

Installs Ansible.

This only needs to be ran on the system you will be running Ansible from.

## Applying Playbook

```bash
ansible-playbook -i ~/ansible-hosts.yml main.yml
```

```bash
ansible-playbook -i ~/ansible-hosts.yml pretty.yml -u ansible --private-key=~/ansible-user
```

Users will need to run the following after deployments to apply themes:

```bash
sudo dconf update
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
