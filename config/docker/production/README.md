## Usage

### Setup kontena.io

```
$ gem install kontena-cli
$ kontena login 52.50.82.108
$ kontena grid use staging
$ kontena vpn config > kontena.ovpn
$ sudo openvpn --config kontena.ovpn --script-security 2 --daemon
```

### Build

```
$ kontena app build
```

### Deploy

```
$ kontena app deploy
```
