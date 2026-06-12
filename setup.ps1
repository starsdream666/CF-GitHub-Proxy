# ============================================================
# CF-GitHub-Proxy 一键配置脚本 (Windows PowerShell)
#
# 用法:
#   .\setup.ps1 <你的代理域名>
#
# 示例:
#   .\setup.ps1 sgh.cfwork.cc.cd
#   .\setup.ps1 ghfile.geekertao.top
#
# 效果: clone/pull 走代理加速，push 自动直连 GitHub
# ============================================================

param (
    [Parameter(Mandatory=$true, HelpMessage="请输入代理域名，如 sgh.cfwork.cc.cd")]
    [string]$Domain
)

# 去掉可能误输入的 https:// 前缀和尾部斜杠
$Domain = $Domain -replace '^https?://', ''
$Domain = $Domain.TrimEnd('/')

$ProxyUrl = "https://${Domain}/https://github.com/"

Write-Host "配置 git insteadOf:" -ForegroundColor Yellow
Write-Host "  代理: $ProxyUrl"
Write-Host "  → 自动替换为: https://github.com/"

git config --global url."https://github.com/".insteadOf "$ProxyUrl"

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ 配置完成!" -ForegroundColor Green
    Write-Host ""
    Write-Host "现在可以这样使用:"
    Write-Host "  git clone https://${Domain}/https://github.com/用户/仓库.git"
    Write-Host "  cd 仓库"
    Write-Host "  # pull 走代理，push 自动直连 GitHub，无需额外操作"
} else {
    Write-Host "✗ 配置失败，请检查 git 是否已安装" -ForegroundColor Red
}
