FROM stackexchange/dnscontrol:4.23.0@sha256:198e3e3d0d082bf4912951b6981a62276eba41bf521b36ce43a481c2f62b73aa
LABEL repository="https://github.com/eliheady/dnscontrol-action-experimental"

LABEL "com.github.actions.name"="DNSControl"
LABEL "com.github.actions.description"="DNSControl GitHub Action using official StackExchange Docker image"

RUN apk update && apk add --no-cache bash~=5

RUN ["dnscontrol", "version"]

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
