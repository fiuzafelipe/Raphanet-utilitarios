@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

title Fiuza Technology - Publicar Release Completa
mode con: cols=85 lines=32
color 0B

echo ==========================================================
echo             FIUZA TECHNOLOGY - GITHUB RELEASE
echo ==========================================================
echo.

set /p versao="1. Digite a TAG da versao (Ex: v1.0.3 ou 1.0.3): "
set /p titulo="2. Digite o TITULO (Ex: Atualizacao v1.0.3): "

echo.
echo ==========================================================
echo Verificando arquivos na pasta releases...

:: Verifica se a pasta releases existe
if not exist "releases\" (
    color 0C
    echo.
    echo ERRO: A pasta "releases" nao foi encontrada!
    echo.
    pause
    exit /b
)

:: Coleta dinamicamente todos os arquivos dentro da pasta releases
set "arquivos_upload="
set "qtd_arquivos=0"

for %%F in ("releases\*") do (
    set "arquivos_upload=!arquivos_upload! "%%F""
    set /a qtd_arquivos+=1
)

:: Verifica se a pasta esta vazia
if !qtd_arquivos! equ 0 (
    color 0C
    echo.
    echo ERRO: A pasta "releases" esta vazia. Adicione os arquivos antes de continuar!
    echo.
    pause
    exit /b
)

echo.
color 0B
echo !qtd_arquivos! arquivo(s) validado(s) com sucesso!
echo Iniciando upload para o repositorio fiuzafelipe/Raphanet-utilitarios...
echo Aguarde, isso pode levar alguns segundos...
echo.

:: Publica a release subindo todos os arquivos concatenados na variavel
gh release create %versao% !arquivos_upload! --repo "fiuzafelipe/Raphanet-utilitarios" --title "%titulo%" --generate-notes

if %errorlevel% neq 0 (
    color 0C
    echo.
    echo ERRO: Falha ao publicar a release. Verifique se a tag %versao% ja existe online.
) else (
    color 0A
    echo.
    echo ==========================================================
    echo RELEASE %versao% PUBLICADA COM SUCESSO!
    echo.
    echo Arquivos enviados com a release:
    :: Lista no console apenas os nomes dos arquivos que foram enviados
    for %%F in ("releases\*") do (
        echo - %%~nxF
    )
    echo ==========================================================
)

echo.
pause