# presearch-install-script
Presearch Node Install Script using docker-compose (currently only supports Ubuntu)

---

## Run Command in Terminal

```bash
curl -sSL https://github.com/id10terror/presearch-install-script/raw/main/presearch-node-install-ubuntu.sh | sudo bash
````
---

If you receive a `curl command not found` error, you can install *curl* first by running this command:
```bash
sudo apt install curl -y
```

---

## Node Registration Code
When prompted for Presearch Node Registration code, browse to https://nodes.presearch.org/dashboard, copy "Your node registration code", and paste code in terminal.

---

## How To BACKUP Keys
Simply browse to the `/opt/docker/presearch/app/node/.keys` directory on your host filesystem and copy the files to a second location.

## How To RESTORE Keys
1. After backing up your keys from your old node, run the script on the new node you wish to restore the keys on. 
2. When prompted, leave the Registration key blank, and press Enter.
3. Press CTRL+C to exit the streaming log.
4. Run this command to stop the containers temporarily:
```bash
$(cd /opt/docker/presearch && docker-compose stop)
```
5. Browse to the `/opt/docker/presearch/app/node/.keys` directory on your host filesystem, and replace the keys with the ones backed up earlier.
6. Run this command to recreate and start the containers:
```bash
$(cd /opt/docker/presearch && docker-compose up -d --force-recreate) &&  docker logs -f presearch-node
```
7. If you did this correctly, you should see a line like this in the log `info: Node is listening for searches...`

*If you see a Duplicate Node error in the log, make sure you have stopped the container in the old node, then wait 30 seconds or so for the error to clear on the new node.*


---

## Demo
[![Demo video](https://img.youtube.com/vi/zKJufbfk8x8/0.jpg)](https://youtu.be/zKJufbfk8x8)

---

### Disclaimer
This script is provided as-is with no support or guarantee. Feel free to review the code, modify, and use as needed.

