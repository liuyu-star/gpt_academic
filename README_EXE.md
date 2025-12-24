# 打包为 Windows 可执行文件 (EXE)

说明：本说明描述如何在 Windows 上将本项目封装为单个可执行文件（使用 PyInstaller）。

1) 先决条件
- 已安装 Python 3.8+ 并可在 PATH 中使用 `python`。
- 项目根目录包含 `main.py`（已存在）。

2) 快速打包（推荐 PowerShell）
- 双击 `build_exe.bat`，或在项目目录用管理员权限运行：

```powershell
.
build_exe.ps1
```

脚本会创建 `venv_build` 虚拟环境，安装 `requirements.txt`（若存在）和 `pyinstaller`，然后执行：

```text
pyinstaller --noconfirm --clean --onefile --name gpt_academic main.py
```

构建完成后，生成的可执行文件位于 `dist\gpt_academic.exe`。

3) 常见问题与调整
- 如果程序在运行时缺失资源（例如模型文件、数据目录等），需把这些资源添加到 PyInstaller 打包参数：
  --add-data "path\to\file;dest_folder"

- 如果遇到隐式导入导致运行出错，请在构建时加 `--hidden-import module_name`，或在 `.spec` 文件中添加。

- 若想显示控制台输出（便于调试），请把 `--noconsole` 去掉。

4) 高级：生成安装程序或包含额外文件
- 可基于生成的 `dist` 目录使用 Inno Setup、NSIS 等工具生成安装包。

如果你希望我现在在当前环境尝试构建（会安装依赖并运行 PyInstaller），回复 "现在构建"。否则我将只创建脚本和说明供你在本地运行。