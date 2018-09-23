with (    let 
      hostPkgs = import <nixpkgs> {};
      pinnedPkgs = hostPkgs.fetchFromGitHub {
        owner = "NixOS";
        repo = "nixpkgs-channels";
        # https://github.com/NixOS/nixpkgs/commit/625c0b35d435922acaa55b1e353da903183a5048
        rev = "625c0b35d435922acaa55b1e353da903183a5048";
        sha256 = "1g22f8r3l03753s67faja1r0dq0w88723kkfagskzg9xy3qs8yw8";
      };
    in
    import pinnedPkgs { });
let
in
haskell.lib.buildStackProject {
  name = "Minimal-example-of";
  buildInputs = [ postgresql zlib ];
}
