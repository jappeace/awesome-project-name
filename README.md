[![Jappiejappie](https://img.shields.io/badge/blog-jappieklooster.nl-lightgrey?style=for-the-badge)](https://jappieklooster.nl)
[![Build status](https://img.shields.io/travis/jappeace/awesome-project-name?style=for-the-badge)](https://travis-ci.org/jappeace/awesome-project-name/builds/)
[![Jappiejappie](https://img.shields.io/badge/twitch.tv-jappiejappie-purple?logo=twitch&style=for-the-badge)](https://www.twitch.tv/jappiejappie)
[![Jappiejappie](https://img.shields.io/badge/youtube-jappieklooster-red?logo=youtube&style=for-the-badge)](https://www.youtube.com/channel/UCQxmXSQEYyCeBC6urMWRPVw)
[![Jappiejappie](https://img.shields.io/badge/discord-jappiejappie-black?logo=discord&style=for-the-badge)](https://discord.gg/Hp4agqy)

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

# Building

A good dev setup is available with:
```bash
make ghcid
```
Adding dependencies now takes updating two dependency
list, checkout this blogpost for the [complete description](https://jappieklooster.nl/ghcid-for-multi-package-projects.html).

Production builds can be made with nix.
You can significantly speedup the building of dependencies
by adding the following binary cache to your `configuration.nix`:

```nix
  nix = {
    binaryCaches = [
      "https://jappie.cachix.org"
    ];
    binaryCachePublicKeys = [
      "jappie.cachix.org-1:+5Liddfns0ytUSBtVQPUr/Wo6r855oNLgD4R8tm1AE4="
    ];
  };
```

This will be automatically updated with help of travis CI.

# Deploy to AWS EC2 with NixOps

* On your AWS console, create a security group called "awesome" in the Oregon region. Give it inbound TCP 22 and 6868 permission.
* `nixops create -d awesome deployment.nix`
* `nixops set-args -d awesome --argstr keyPair <your-aws-key.pem>`
* `nixops set-args -d awesome --argstr accessKeyId <your-aws-access-key>`
* `nixops deploy -d awesome`


# Similar projects
Other people have had similar ideas:

+ https://github.com/thalesmg/reflex-skeleton/
+ https://github.com/ElvishJerricco/reflex-project-skeleton
+ https://github.com/ghorn/reflex-skeleton
