#!/usr/bin/env python3
"""Cria um app iOS a partir do template BaseApp deste repositório."""
import argparse
from pathlib import Path
import re
import shutil
import sys

ROOT = Path(__file__).resolve().parents[1]
TEMPLATE = ROOT / "template"


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("name", help="Nome do app/target: letras, números e underscore; começa com letra")
    parser.add_argument("destination", type=Path, help="Diretório novo onde criar o projeto")
    parser.add_argument("--bundle-id", required=True, help="Identificador único, ex.: com.example.MeusPedidos")
    args = parser.parse_args()
    if not re.fullmatch(r"[A-Za-z][A-Za-z0-9_]*", args.name):
        parser.error("name deve começar com letra e conter apenas letras, números ou underscore")
    if not re.fullmatch(r"[A-Za-z][A-Za-z0-9-]*(?:\.[A-Za-z][A-Za-z0-9-]*)+", args.bundle_id):
        parser.error("--bundle-id deve ter segmentos separados por ponto")
    target = args.destination.expanduser().resolve()
    if target.exists():
        parser.error(f"destino já existe: {target}")
    shutil.copytree(TEMPLATE, target)
    shutil.copytree(ROOT / "docs", target / "docs")
    project = target / "BaseApp.xcodeproj"
    source = target / "BaseApp"
    scheme = project / "xcshareddata/xcschemes/BaseApp.xcscheme"
    for path in (project / "project.pbxproj", scheme, source / "BaseApp.swift", target / "README.md"):
        text = path.read_text()
        text = text.replace("com.example.BaseApp", args.bundle_id).replace("BaseApp", args.name)
        path.write_text(text)
    scheme.rename(scheme.with_name(f"{args.name}.xcscheme"))
    (source / "BaseApp.swift").rename(source / f"{args.name}App.swift")
    source.rename(target / args.name)
    project.rename(target / f"{args.name}.xcodeproj")
    print(f"Criado: {target}")
    print(f"Projeto: {target / (args.name + '.xcodeproj')}")
    print("Próximos passos: selecionar equipe de assinatura e adicionar ícone antes de distribuir.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
