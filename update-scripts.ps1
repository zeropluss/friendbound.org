# 批量更新网站脚本加载器
# 将所有页面的外部脚本替换为智能加载器

Write-Host "开始批量更新网站脚本..." -ForegroundColor Green

# 定义要替换的原始脚本块
$oldScriptBlock = @"
    <!-- Click Analytics -->
    <script defer data-domain="friendbound.org" src="https://click.pageview.click/js/script.js"></script>
    
    <!-- Google tag (gtag.js) -->
    <script async src="https://www.googletagmanager.com/gtag/js?id=G-RPMXFWKW5R"></script>
    <script>
      window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag('js', new Date());

      gtag('config', 'G-RPMXFWKW5R');
    </script>
    
    <!-- Google AdSense -->
    <script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-6762879731814955"
         crossorigin="anonymous"></script>
"@

# 定义替换的脚本块
$newScriptRoot = "    <!-- Smart Script Loader - 开发环境友好版本 -->`n    <script src=`"assets/js/smart-loader.js`"></script>"
$newScriptLevel1 = "    <!-- Smart Script Loader - 开发环境友好版本 -->`n    <script src=`"../assets/js/smart-loader-level1.js`"></script>"
$newScriptLevel2 = "    <!-- Smart Script Loader - 开发环境友好版本 -->`n    <script src=`"../../assets/js/smart-loader-level2.js`"></script>"

# 获取所有 HTML 文件
$htmlFiles = Get-ChildItem -Recurse -Filter "*.html" | Where-Object { $_.Name -ne "placeholder.html" }

$updatedCount = 0
$totalCount = $htmlFiles.Count

foreach ($file in $htmlFiles) {
    $relativePath = $file.FullName.Replace((Get-Location).Path + "\", "")
    Write-Host "处理: $relativePath" -ForegroundColor Yellow
    
    # 读取文件内容
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    
    # 检查是否包含需要替换的脚本
    if ($content -match "click\.pageview\.click") {
        # 确定目录层级
        $depth = ($relativePath -split "\\").Length - 1
        
        $newScript = switch ($depth) {
            0 { $newScriptRoot }
            1 { $newScriptLevel1 }
            2 { $newScriptLevel2 }
            default { $newScriptLevel2 }
        }
        
        # 执行替换
        $newContent = $content -replace [regex]::Escape($oldScriptBlock), $newScript
        
        # 如果内容有变化，写回文件
        if ($newContent -ne $content) {
            Set-Content $file.FullName -Value $newContent -Encoding UTF8
            $updatedCount++
            Write-Host "  ✅ 已更新" -ForegroundColor Green
        } else {
            Write-Host "  ⚠️  未找到匹配的脚本块" -ForegroundColor Orange
        }
    } else {
        Write-Host "  ℹ️  无需更新" -ForegroundColor Gray
    }
}

Write-Host "`n更新完成！" -ForegroundColor Green
Write-Host "总文件数: $totalCount" -ForegroundColor Cyan
Write-Host "已更新: $updatedCount" -ForegroundColor Cyan