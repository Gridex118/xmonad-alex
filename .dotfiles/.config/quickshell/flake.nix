{
  description = "Devshell Declaration for Qt Development";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {nixpkgs, ...}: let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in {
    devShells.${system} = {
      default = pkgs.mkShell {
        packages = with pkgs.qt6; [
          qtdeclarative
          qtbase
        ];
        shellHook = ''
          export QML_IMPORT_PATH="${pkgs.qt6.qtdeclarative}/lib/qt-6/qml"
        '';
      };
    };
  };
}
