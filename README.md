csync2
======

Installs and configures [csync2](http://oss.linbit.com/csync2/)

## Usage

```
include_recipe[csync2]
```

csync2 uses a set of ssl keys that are shared between nodes which
are syncing files together. You should generate a set of these keys
and store them in an encrypted data bag named csync2.

* Install csync2
* Generate entropy to quickly generate keys
```
command "rngd -r /dev/urandom -o /dev/random -b"
```
* Generate csync2 key
```
/usr/sbin/csync2 -k /etc/csync2.key
```
* Generate cysnc2 SSL
```
openssl genrsa -out /etc/csync2_ssl_key.pem 1024
openssl req -batch -new -key /etc/csync2_ssl_key.pem -out /etc/csync2_ssl_cert.csr
openssl x509 -req -days 3600 -in /etc/csync2_ssl_cert.csr -signkey /etc/csync2_ssl_key.pem -out /etc/csync2_ssl_cert.pem
```
* Create data bag item containing the following files data
```
cat /etc/csync2.key
cat /etc/csync2_ssl_cert.csr | sed s/$/\\\\n/ | tr -d '\n'
cat /etc/csync2_ssl_cert.pem | sed s/$/\\\\n/ | tr -d '\n'
cat /etc/csync2_ssl_key.pem | sed s/$/\\\\n/ | tr -d '\n'
```

```json
{
  "id": "default",
  "csync2.key": "PgdgAFKCz2unW.0wsU6b.JofIIhPJFE2BR3XpfWASlMdTx_Z3xLQZ3j26AVFpwqI",
  "csync2_ssl_cert.csr": "-----BEGIN CERTIFICATE REQUEST-----\nMIIBgTCB6wIBADBCMQswCQYDVQQGEwJYWDEVMBMGA1UEBwwMRGVmYXVsdCBDaXR5\nMRwwGgYDVQQKDBNEZWZhdWx0IENvbXBhbnkgTHRkMIGfMA0GCSqGSIb3DQEBAQUA\nA4GNADCBiQKBgQCp9D8tDNJ6S92zXqgUFMCpQ+rpaSsCKjFlqwgScaf/hIn+MB8W\n/5YC6meQyNfYFF9fIvD+Dgk5uYzpguKDom318f6uJayHocE9rq0cF6sAwK2nYyTr\nkjCnPYDVKIUmSP6MNaK9wnwy+ccnG6fP9FA0NOM0j/rrXtxRlCGLVkVwiwIDAQAB\noAAwDQYJKoZIhvcNAQEFBQADgYEAQCufOwUppz/ggcispTr+zTNEUKqbAwXiFz7u\nI1UReUk68igZxXe2o1M727DH96GfXJuKRqWe5TdVFXJS6VPWktPnhNAGP18+C1mn\nAWKp6vDsmKLtjg0Bt6a5aPcZLGSvff9R4lo9DlFYcRp/X1jmHdwfIsUtpdI5EbOv\n06I2jLg=\n-----END CERTIFICATE REQUEST-----\n",
  "csync2_ssl_cert.pem": "-----BEGIN CERTIFICATE-----\nMIIB+zCCAWQCCQDOc2x4XgXhhjANBgkqhkiG9w0BAQUFADBCMQswCQYDVQQGEwJY\nWDEVMBMGA1UEBwwMRGVmYXVsdCBDaXR5MRwwGgYDVQQKDBNEZWZhdWx0IENvbXBh\nbnkgTHRkMB4XDTE0MTExODA3NTk0MloXDTI0MDkyNjA3NTk0MlowQjELMAkGA1UE\nBhMCWFgxFTATBgNVBAcMDERlZmF1bHQgQ2l0eTEcMBoGA1UECgwTRGVmYXVsdCBD\nb21wYW55IEx0ZDCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAqfQ/LQzSekvd\ns16oFBTAqUPq6WkrAioxZasIEnGn/4SJ/jAfFv+WAupnkMjX2BRfXyLw/g4JObmM\n6YLig6Jt9fH+riWsh6HBPa6tHBerAMCtp2Mk65Iwpz2A1SiFJkj+jDWivcJ8MvnH\nJxunz/RQNDTjNI/6617cUZQhi1ZFcIsCAwEAATANBgkqhkiG9w0BAQUFAAOBgQCM\nzpFFDrXl/HMmqaQc+xM5ekdMlzoIrVZ9l5VjTGimj/3JHFxvIiS4RhIpHknjyZjV\nTvcCoXpxA1BtNOPQeFZLyetJ6Lo4a9xU1j+OH/50f5B8KExWsyn2ZJcpSiU4ubGZ\nMkIfs6onWsRio/bfOXTbT6OkAvfzLQF9+0ctrR22Yw==\n-----END CERTIFICATE-----\n",
  "csync2_ssl_key.pem": "-----BEGIN RSA PRIVATE KEY-----\nMIICXAIBAAKBgQCp9D8tDNJ6S92zXqgUFMCpQ+rpaSsCKjFlqwgScaf/hIn+MB8W\n/5YC6meQyNfYFF9fIvD+Dgk5uYzpguKDom318f6uJayHocE9rq0cF6sAwK2nYyTr\nkjCnPYDVKIUmSP6MNaK9wnwy+ccnG6fP9FA0NOM0j/rrXtxRlCGLVkVwiwIDAQAB\nAoGAfYjEAWqvLVZMc+k/DVYm2OAp7C6abgbsZcRnOfhptvsXUoII9Nvk2lJ6HR+9\nDwY9S/BrQbzsY48C3pim58Rao1NnzjtMgsaY3u/6Gw8qgiPTZx8FuQ0Tt4nWgNn4\nynYg+8MFI/h1HWXL1I/LupSvv1UWgIGp8ZHWxbdr3skTYwECQQDdMTJcb9FwkYpn\nDk83IqZqC+JA8c91GbxamDoOcpy21+HdFqY3Tp1atP2JlMMtd19GzfiGwclGbJDP\nF+/9A4BRAkEAxLLn8uUlcXlJCtHOel+7MCU+qz+3iPKCUPWqHktf53dVwL6nfCc/\n7ybWi4Ppngz5oIDVhnBpUg6Td+dDUuZoGwJAcCFLfW62BtHRDrNDVxj6sdG6bd/n\nol5cjLSU4dQaO9quxkyAEJOK03vi94bxdrAIHbW2omHEri3FLybcYzAOMQJBAIVo\n2o0SAj1eh74A40x41ZsoB8Naqf8GjICgvsthUCDL/auHJE2+yUxJSUbDJ5Z9Mmo8\nN5bBc42mOTsf7beycnUCQBF6c9+ryPD78lJ7Hb0i+JBzyFjlOxo49ZMMV0NMss5I\nUa5olxckbWiAuvJebilXz5hiFOxVAWS41nzN6KeIrRM=\n-----END RSA PRIVATE KEY-----\n"
}
```

## License & Authors

- Author:: Aaron Baer (<aaron@hw-ops.com>)

```text
Copyright:: Heavy Water Operations, LLC.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

## Development / Contributing

* Source hosted at [GitHub][repo]
* Report issues/questions/feature requests on [GitHub Issues][issues]

Pull requests are very welcome! Make sure your patches are well tested.
Ideally create a topic branch for every separate change you make. For
example:

1. Fork the repo
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Write some tests, see [ChefSpec](https://github.com/sethvargo/chefspec)
4. Commit your awesome changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request and tell us about it your changes.
