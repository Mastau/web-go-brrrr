#!/bin/sh
set -eu

image_name="${CYBERLAB_IMAGE:-cyberlab:latest}"
tools="ffuf feroxbuster sqlmap nuclei httpx subfinder nmap whatweb dalfox gau arjun nikto gobuster wafw00f python3 go"

for tool in ${tools}; do
    docker run --rm --entrypoint /bin/sh "${image_name}" -c "command -v ${tool} >/dev/null"
done

echo "Image smoke tests passed"
