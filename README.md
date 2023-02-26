# Bark

<img src="https://wx3.sinaimg.cn/mw690/0060lm7Tly1g0nfnjjxbbj30sg0sg757.jpg" width=200px height=200px />

个人修改版，支持 markdown 推送，适用于私有服务器搭建，原版请查看 [https://github.com/Finb/Bark](https://github.com/Finb/Bark) 

前端源码请查看 [https://github.com/adams549659584/bark-md-reader](https://github.com/adams549659584/bark-md-reader) 


## Push

| Field | Type | Description |
| ----- | ---- | ----------- |
| title | string | Notification title (font size would be larger than the body) |
| body  | string | Notification content |
| category | string | Reserved field, no use yet |
| device_key | string | The key for each device |
| level (optional) | string | `'active'`, `'timeSensitive'`, or `'passive'` |
| badge (optional) | integer | The number displayed next to App icon ([Apple Developer](https://developer.apple.com/documentation/usernotifications/unnotificationcontent/1649864-badge)) |
| automaticallyCopy (optional) | string | Must be `1` |
| copy (optional) | string |  The value to be copied |
| sound (optional) | string | Value from [here](https://github.com/Finb/Bark/tree/master/Sounds) |
| icon (optional) | string | An url to the icon, available only on iOS 15 or later |
| group (optional) | string | The group of the notification |
| isArchive (optional) | string | Value must be `1`. Whether or not should be archived by the app |
| url (optional) | string | Url that will jump when click notification |
| **markdown** (optional) | string | will auto create or replace jump url |

### curl

```sh
curl -X "POST" "http://127.0.0.1:8080/push" \
     -H 'Content-Type: application/json; charset=utf-8' \
     -d $'{
  "device_key": "your key",
  "title": "bleem",
  "body": "Test Bark Server",
  "badge": 1,
  "category": "category",
  "sound": "minuet.caf",
  "icon": "https://day.app/assets/images/avatar.jpg",
  "group": "test",
  "markdown": "# markdown title \\n > markdown text"
}'
```

### fetch

```js
fetch('http://127.0.0.1:8080/push', {
  headers: {
    'Content-Type': 'application/json; charset=utf-8',
  },
  method: "POST",
  body: JSON.stringify({
    device_key: 'your key',
    title: 'bleem',
    body: 'Test Bark Server',
    badge: 1,
    category: 'category',
    sound: 'minuet.caf',
    icon: 'https://day.app/assets/images/avatar.jpg',
    group: 'test',
    markdown: '# markdown title \\n > markdown text',
  }),
}).then(res => res.json()).then(res => console.log(res));
```

## Installation

### For Docker User

![Docker Automated build](https://img.shields.io/docker/automated/adams549659584/bark-server.svg) ![Image Size](https://img.shields.io/docker/image-size/adams549659584/bark-server?sort=date) ![License](https://img.shields.io/github/license/adams549659584/bark-server)

The docker image is already available, you can use the following command to run the bark server:

``` sh
docker run -dt --name bark -p 8080:8080 -v `pwd`/bark-data:/data adams549659584/bark-server
```

If you use the docker-compose tool, you can copy docker-copose.yaml under this project to any directory and run it:

``` sh
mkdir bark-server && cd bark-server
curl -sL https://raw.githubusercontent.com/Finb/bark-server/master/deploy/docker-compose.yaml > docker-compose.yaml
docker-compose up -d
```

### For General User 

- 1、Download precompiled binaries from the [releases](https://github.com/adams549659584/bark-server/releases) page
- 2、Add executable permissions to the bark-server binary: `chmod +x bark-server`
- 3、Start bark-server: `./bark-server --addr 0.0.0.0:8080 --data ./bark-data`
- 4、Test the server: `curl localhost:8080/ping`

**Note: Bark-server uses the `/data` directory to store data by default. Make sure that bark-server has permission to write to the `/data` directory, otherwise use the `-d` option to change the directory.**

### For Developer

Developers can compile this project by themselves, and the dependencies required for compilation:

- Golang 1.18+
- Go Mod Enabled(env `GO111MODULE=on`)
- Go Mod Proxy Enabled(env `GOPROXY=https://goproxy.cn`)
- [go-task](https://taskfile.dev/installation/) Installed

Run the following command to compile this project:

```sh
# Cross compile all platforms
task

# Compile the specified platform (please refer to Taskfile.yaml)
task linux_amd64
task linux_amd64_v3
```

**Note: The linux amd64 v3 architecture was added in go 1.18, see [https://github.com/golang/go/wiki/MinimumRequirements#amd64](https://github.com/golang/go/wiki/MinimumRequirements#amd64)**

### Nginx Proxy

Most users want to deploy the bark server on the intranet server, and then use Nginx to reverse proxy the bark server;
here is a simple Nginx configuration example (we assume that the bark server is listening at `192.168.1.123:8080`)

```sh
# generated 2020-03-26, Mozilla Guideline v5.4, nginx 1.17.7, OpenSSL 1.1.1d, modern configuration
# https://ssl-config.mozilla.org/#server=nginx&version=1.17.7&config=modern&openssl=1.1.1d&guideline=5.4
server {
    listen 80;
    listen [::]:80;
    # Replace bark.app.dev with your real domain name.
    server_name bark.app.dev;

    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    # Replace bark.app.dev with your real domain name.
    server_name bark.app.dev;

    ssl_certificate /path/to/signed_cert_plus_intermediates;
    ssl_certificate_key /path/to/private_key;
    ssl_session_timeout 1d;
    ssl_session_cache shared:MozSSL:10m;  # about 40000 sessions
    ssl_session_tickets off;

    # modern configuration
    ssl_protocols TLSv1.3;
    ssl_prefer_server_ciphers off;

    # HSTS (ngx_http_headers_module is required) (63072000 seconds)
    add_header Strict-Transport-Security "max-age=63072000" always;

    # OCSP stapling
    ssl_stapling on;
    ssl_stapling_verify on;

    # verify chain of trust of OCSP response using Root CA and Intermediate certs
    ssl_trusted_certificate /path/to/root_CA_cert_plus_intermediates;

    # replace with the IP address of your resolver
    #resolver 127.0.0.1;

    location / {

        log_not_found on;
        # Replace http://192.168.1.123:8080 with the listening address of the bark server.
        proxy_pass http://192.168.1.123:8080;

        proxy_read_timeout 300;
        proxy_connect_timeout 300;
        proxy_redirect off;

        proxy_set_header Host              $host;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Real-IP         $remote_addr;

    }
}
```

### Use MySQL instead of Bbolt

Just run the server with `-dsn=user:pass@tcp(mysql_host)/bark`, it will use MySQL instead of file database Bbolt

## API V2

Please read [API_V2.md](docs/API_V2.md).

## Other

### 中文:

- [https://day.app/2018/06/bark-server-document](https://day.app/2018/06/bark-server-document)

### Markdown support:

- [https://github.com/adams549659584/bark-server](https://github.com/adams549659584/bark-server)

## Contributing to bark-server

### Development environment

This project requires at least the golang 1.12 version to compile and requires Go mod support.

- Golang 1.16
- GoLand 2020.3 or other Go IDE
- Docker(Optional)

## Update 

Now the push certificate embedded in the program will never expire. You only need to update the program if the push fails due to the expired certificate.
