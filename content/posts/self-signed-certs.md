---
title: "Trusting self signed certificates with Kubernetes Ingress Controller"
date: 2024-01-26T15:11:55+01:00
---

I have a very complicated development environment, which spins up a local
Kubernetes cluster on Kind and then deploys a bunch of services to it.

Some of the services gets accessed by the browser and until late I was deploying
everything on localhost which so far did not cause any issues, since the browser
are good at trusting localhost.

But since my laptop was getting slower and slower and I had a new raspberry pi 5
unused with a SSD, I decided to made it my local Kubernetes cluster.

Deploying Kubernetes on a Raspberry Pi 5 running the raspbian distribution with
nix is probably a post on its own, but let's assume it's already deployed. Now
I have a new issue, since we are not running on localhost the browser don't
trust it anymore and everytime I redeploy I need to click again on those pesky
"Trust me bro, I know what I'm doing" (or something along those lines) scary
box.

I spent a bit of time reading this LetsEncrypt blog post
<https://letsencrypt.org/docs/certificates-for-localhost/> which had a link to
this fantastic tool called [minica](https://github.com/jsha/minica/). It's
pretty straightforward it create a CA root and then create domains out of it.

In your browsers you only trust the CA root and everytime you generate domains,
they are being trusted.

## Generating a certificate and deploying an Ingress

To plug this with ingress-nginx I do something like this:

1. First generate a domain for `$domain` with minica:

```bash
mkdir -p minica;cd minica/
minica -domains $domain
```

(if it is already generated then the `minica` command will fail then make sure it's not)

2. You will hen create a Kubernetes secret out of it which we will call `$sec_name` on
   namespace `$namespace` using the generate secret from `minica.`

```bash
key_file=minica/${domain}/key.pem
cert_file=minica/${domain}/cert.pem
kubectl create secret tls ${sec_name} --key ${key_file} --cert ${cert_file} -n ${namespace}
```

3. And then we create a Ingress out of it for a `component` on `targetPort`
   expose as ${host} (for example for a docker registry, I use `docker-registry`
   as component, `5000` as `targetPort` and `host` as `registry.local` which
   resolve via my local DNS but you can use a `/etc/host` entry too)

```bash
cat <<EOF | kubectl apply -f -
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: "${component}"
  namespace: "${namespace}"
spec:
  ingressClassName: nginx
  tls:
    - hosts:
        - "${host}"
      secretName: "${sec_name}"
  rules:
    - host: "${host}"
      http:
        paths:
          - pathType: ImplementationSpecific
            backend:
              service:
                name: "${component}"
                port:
                  number: ${targetPort}
EOF
```

For the docker registries you actually need some other annotations to give to
ingress nginx to let know that large blobs are OK, here is what I do to actually
set those, you don't need to set them if your service don't need to increase the
read/send timeout nginx settings.

```bash
for annotations in "nginx.ingress.kubernetes.io/proxy-body-size=0" \
 "nginx.ingress.kubernetes.io/proxy-read-timeout=600" \
 "nginx.ingress.kubernetes.io/proxy-send-timeout=600" \
 "kubernetes.io/tls-acme=true"; do
 kubectl -v=0 annotate ingress -n ${namespace} ${component} "${annotations}"
done
```

## Using the certificate

### Linux (generic)

On Linux you can install the certificate system wise by issuing this command:

```bash
sudo trust anchor -v --store minica/minica.pem
```

### NixOS

If you are using Nix you can simply use the option [security.pki.cert](https://search.nixos.org/options?channel=unstable&show=security.pki.certificates&from=0&size=50&sort=relevance&type=packages&query=security.pki.cert) and include the certificate in your configuration.

### Curl

If you are not installing the certificate system wise you can still use curl with the custom certificate by specifying the cacert argument:

```bash
curl --cacert minica/minica.pem https://${host}
```

### Firefox

As for Firefox you have to go to the settings and search for `view certificates` in the search box, go
to the `Authorities` tab click on Import use the `minica.pem` file as generated in
the `minica/` directory and trust it as root domain by checking the
checkbox. Now if you go to the https://${host} it should not bring any scary
messages.

### Chrome browsers

Almost the same thing with chrome browser, I use Brave but that should apply to
others. Go to this URL in your browser to see the certificates (it's in the
security section if you look for it from the home settings)

<brave://settings/certificates>

go to the authorities tab and import your `minica.pem` from the `minica/`
directory and you should be good to go.

### Python request

Just for completeness using python requests you can simply specify the root certificates by
using the non obvious keyword verify:

```python
                r = requests.get(
                    f"https://{domain}/",
                    verify="minica/minica.pem",
                )
```

## Conclusion

There is no reason to don't use SSL domains for your local services on your
cluster and you won't need to spend your precious time clicking on those "trust
me" button anymore.
