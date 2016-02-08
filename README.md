# Installation

Install ansible on host machine.

```
cd cm && make ansible/install_roles && cd ..
vagrant up
```

Then login to you new virtual machine with `vagrunt ssh` and configure project with
`./bin/setup` command
