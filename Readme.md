# Some kind of working Coturn

This is a POC setup with basic configurations for Coturn

## Start Coturn

```bash
docker-compose -f docker-compose.yml up --build --detach
```

## Check web interface

Open the browser on https://localhost:8080

## Check CLI

Use telnet to connect to the CLI

```bash
telnet localhost 5766

Trying ::1...
Connected to localhost.
Escape character is '^]'.
TURN Server
Coturn-4.5.2 'dan Eider'

Type '?' for help
Enter password:
qwerty
> ?
TURN Server
Coturn-4.5.2 'dan Eider'

  ?, h, help - print this text

  quit, q, exit, bye - end CLI session

  stop, shutdown, halt - shutdown TURN Server

  pc - print configuration

  sr <realm> - set CLI session realm

  ur - unset CLI session realm

  so <origin> - set CLI session origin

  uo - unset CLI session origin

  tc <param-name> - toggle a configuration parameter
     (see pc command output for togglable param names)

  cc <param-name> <param-value> - change a configuration parameter
     (see pc command output for changeable param names)

  ps [username] - print sessions, with optional exact user match

  psp <usernamestr> - print sessions, with partial user string match

  psd <file-name> - dump ps command output into file on the TURN server system

  pu [udp|tcp|dtls|tls]- print current users

  lr - log reset

  aas ip[:port} - add an alternate server reference
  das ip[:port] - delete an alternate server reference
  atas ip[:port] - add a TLS alternate server reference
  dtas ip[:port] - delete a TLS alternate server reference

  cs <session-id> - cancel session, forcefully
```

## Restart

Notice: May restart needed for coturn container, if it could not access database yet, due initialization delay.

```bash
docker restart docker_coturn_1
```

## Stop

```bash
docker-compose -f docker-compose.yml down
```

## Or Stop with volume removal

```bash
docker-compose down --volumes
```
