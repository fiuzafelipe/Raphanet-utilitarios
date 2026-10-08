@echo off
:: Essa linha garante que ele vai olhar na pasta certa do seu PC
cd /d "%~dp0"

title Fiuza Technology - Apagar Release no GitHub
mode con: cols=85 lines=25
color 0B

echo ==========================================================
echo             FIUZA TECHNOLOGY - APAGAR RELEASE
echo ==========================================================
echo.

set /p versao="Digite a TAG da versao que deseja apagar (Ex: v1.0.2): "

echo.
echo ==========================================================
echo Deletando a release %versao% e sua tag correspondente no GitHub...
echo Aguarde...
echo.

:: --cleanup-tag apaga a tag do repositorio junto com a release
:: -y confirma automaticamente a exclusao sem perguntar (Y/N) na tela
gh release delete %versao% --repo "fiuzafelipe/Pack-full-aplicacoes-socin" --cleanup-tag -y

if %errorlevel% neq 0 (
    color 0C
    echo.
    echo ERRO: Falha ao apagar a release. Verifique se a tag "%versao%" realmente existe online.
) else (
    color 0A
    echo.
    echo ==========================================================
    echo RELEASE %versao% APAGADA COM SUCESSO!
    echo ==========================================================
)

echo.
pause