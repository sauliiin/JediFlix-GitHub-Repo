# Instalação do JediFlix

## Antes de instalar

- O APK atual usa o pacote `org.xbmc.kodi`.
- Isso pode substituir uma instalação existente do Kodi oficial no Android.
- Faça backup dos seus dados antes de instalar.

## Passo a passo

1. Copie `release/jediflixapp-armeabi-v7a-release.apk` para o dispositivo Android.
2. Ative a permissão para instalar apps de fontes desconhecidas.
3. Abra o APK no gerenciador de arquivos.
4. Confirme a instalação.
5. Abra o app e valide se suas personalizações carregaram corretamente.

## Verificação rápida

- Confira o nome do app exibido como `JediFlix`.
- Valide as configurações em `userdata/` no seu projeto-fonte, se estiver comparando comportamento.
- Se o Android reclamar de conflito de assinatura, desinstale a versão anterior compatível ou use um pacote diferente em builds futuros.
