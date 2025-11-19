{
  lib,
  pkgs,
  rustPlatform,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "rudpt";
  version = "0.1.2";
  src = ./rudpt-0.1.2.tar.gz;
  cargoLock.lockFile = ./Cargo.lock;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    # cp target/release/rudpt $out/bin/
    cp target/x86_64-unknown-linux-gnu/release/rudpt $out/bin/
    # ls -alh
    # ls src -alh
    # ls target -alh
    # ls target/release -alh
    # ls target/release/build -alh
    # ls target/x86_64-unknown-linux-gnu -alh
    # ls target/x86_64-unknown-linux-gnu/release -alh
    # ls $out -alh
    # find target/release -maxdepth 1 -executable -type f -exec cp "{}" $out/bin \;

    # Копируем config.toml в /share/rudpt
    mkdir -p $out/share/rudpt
    cp src/config.toml $out/share/rudpt/config.toml

    runHook postInstall
  '';

  # Build dependencies
  nativeBuildInputs = [pkg-config];
  buildInputs = [openssl];

  # Disable tests if they need network access
  doCheck = false;

  # Метаинформация
  meta = with lib; {
    description = "Rust telegram bot to monitor int. servers states";
    homepage = "https://void.nu";
    license = licenses.mit;
    maintainers = [alexdeb];
    platforms = platforms.linux;
  };
}
