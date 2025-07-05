{ self, lib, ... }:
{
  sops.defaultSopsFile = lib.mkDefault "${self}/.sops.yaml";
}
