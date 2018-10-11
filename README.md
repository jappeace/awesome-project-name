## Deploy to AWS EC2 with NixOps

* On your AWS console, create a security group called "awesome" in the Oregon region. Give it inbound TCP 22 and 6868 permission.
* `nixops create -d awesome deployment.nix`
* `nixops set-args -d awesome --argstr keyPair <your-aws-key.pem>`
* `nixops set-args -d awesome --argstr accessKeyId <your-aws-access-key>`
* `nixops deploy -d awesome`
