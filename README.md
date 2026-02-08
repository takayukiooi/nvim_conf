# nvim_conf

## 📁 Project Structure

```text
.
├── init.lua              # エントリポイント
└── lua/
    ├── core/             # 基本設定（options, autocmds）
    ├── keymaps.lua       # すべてのキーマップをここに集約
    ├── plugins/          # プラグイン設定
    │   ├── lsp.lua       # LSP (Mason, lspconfig)
    │   ├── snacks.lua    # Snacks.nvim モジュール設定
    │   ├── mini.lua      # mini.nvim 各種モジュール
    │   └── ui.lua        # その他UI関連
    └── utils/            # 共通ユーティリティ

```

## 🛠️ Key Components

### 1. The Powerhouse (Snacks & mini)

機能が重複する場合、基本的には **Snacks.nvim** を優先的に試用。

* **Snacks.nvim**: Dashboard, Picker, Input, Notifier 等
* **mini.nvim**: Ai, Surrounding, Pairs, Comment 等

### 2. Language Server Protocol (LSP)

`kickstart.nvim` をリスペクトした構成。

* **Mason.nvim**: バイナリ管理
* **nvim-lspconfig**: LSPサーバー設定
* **nvim-cmp**: 自動補完

### 3. Keybindings

キーマップの分散を防ぐため、プラグイン固有の設定を除き、可能な限り `lua/keymaps.lua` に記述。

## 📋 Installation

```bash
git clone https://github.com/renoinn/nvim_conf.git
ln -s ./nvim_conf ~/.config/nvim
nvim
```
