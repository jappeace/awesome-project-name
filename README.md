[![Jappiejappie](https://img.shields.io/badge/blog-jappieklooster.nl-lightgrey?style=for-the-badge)](https://jappieklooster.nl)

This is a reference project for my blog posts about Haskell web services.
Usually my workflow is:

1.	Find something cool out during work, let's call it `A`.
2.  Port `A` to this project.
3.	Write words about `A` on my [blog](https://jappieklooster.nl)

I link to branches from blog post to make sure they remain
relevant and not cluttered from the result of new blog posts.
Branches also allow me to do fixes when necessary.
Currently the ones I've wrote about are:

+ [Pragmatic haskell series](https://jappieklooster.nl/tag/pragmatic-haskell.html).
+ [Reflex and servant](https://jappieklooster.nl/fullstack-haskell-reflex-and-servant.html).
+ [Reflex authentication](https://jappieklooster.nl/authentication-in-reflex-servant.html).
+ [Reflex server side rendering](https://jappieklooster.nl/reflex-server-side-html-rendering.html)

## Deploy to AWS EC2 with NixOps

* On your AWS console, create a security group called "awesome" in the Oregon region. Give it inbound TCP 22 and 6868 permission.
* `nixops create -d awesome deployment.nix`
* `nixops set-args -d awesome --argstr keyPair <your-aws-key.pem>`
* `nixops set-args -d awesome --argstr accessKeyId <your-aws-access-key>`
* `nixops deploy -d awesome`


## Similar projects
Other people have had similar ideas:

+ https://github.com/thalesmg/reflex-skeleton/
+ https://github.com/ElvishJerricco/reflex-project-skeleton
