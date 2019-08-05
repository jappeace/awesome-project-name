# Awesome project name

This is a reference project for my blog posts.
Usually my workflow is:

1.	Find something cool out during work, let's call it `A`.
2.  Port `A` to this project.
3.	Write words about `A` on my [blog](https://jappieklooster.nl)

I link to branches from blogpost to make sure they remain
relevant and not cluttered.

## Deploy to AWS EC2 with NixOps

* On your AWS console, create a security group called "awesome" in the Oregon region. Give it inbound TCP 22 and 6868 permission.
* `nixops create -d awesome deployment.nix`
* `nixops set-args -d awesome --argstr keyPair <your-aws-key.pem>`
* `nixops set-args -d awesome --argstr accessKeyId <your-aws-access-key>`
* `nixops deploy -d awesome`
