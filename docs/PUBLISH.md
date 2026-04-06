# Publicar no GitHub

## Passo a passo

1. Crie um repositório novo no GitHub.
2. No terminal, entre nesta pasta:

```bash
cd /home/saulin/JediDevelopment/JediFlix-GitHub-Repo
```

3. Inicialize o Git e faça o primeiro commit:

```bash
git init
git add .
git commit -m "feat: initial JediFlix APK repository"
git branch -M main
```

4. Conecte ao seu repositório remoto:

```bash
git remote add origin https://github.com/SEU-USUARIO/SEU-REPO.git
git push -u origin main
```

## Dica

- O APK atual tem menos de 100 MB, então no GitHub ele ainda cabe no repositório.
- Se no futuro você quiser guardar vários APKs grandes, usar GitHub Releases pode ser um caminho melhor.
