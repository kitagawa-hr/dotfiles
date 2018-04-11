# cancerscan/dotfiles
## データ解析用環境構築手順
### 1. dotfilesのリポジトリをクローン
```
$ cd
$ git clone https://github.com/cancerscan/dotfiles
```
### 2. 設定ファイルの配置
```
$ cd ~/dotfiles
$ ./bin/deploy.sh
```
### 3. 必要なパッケージのインストール
```
$ cd ~/dotfiles
$ ./bin/install.sh
```
## Python環境構築手順
### pyenv
複数のバージョンのPythonを共存させるためのツール
https://github.com/pyenv/pyenv
#### 1. Pythonのインストール
Python 3.6.5をインストールする
```
$ pyenv install 3.6.5
```
#### 2. インストール済みのPythonの確認
```
$ pyenv versions
* system
  3.6.5
```
アスタリスクが付いているものが現在選択されているPythonのバージョンとなる。
systemはOSXが利用する2.7系のPythonなので、開発用には新たに3系をインストールして利用すること。
#### 3. デフォルトで実行されるPythonの切り替え
```
$ pyenv global 3.6.5
$ python --version
Python 3.6.5
```
#### 4. 特定のディレクトリで実行されるPythonの切り替え
```
$ cd /path/to/your/project
$ pyenv local 3.6.5
$ python --version
Python 3.6.5
```
### venv
3系で公式採用された仮想環境作成モジュール
3.3以降で利用可能
https://docs.python.jp/3/library/venv.html
#### 1. プロジェクト用の仮想環境作成
```
$ cd /path/to/your/project
$ python -m venv ./venv
```
#### 2. 仮想環境の有効化
```
$ cd /path/to/your/project
$ source ./venv/bin/activate
```
#### 3. 仮想環境へのパッケージインストール
pipコマンドは必ず一般ユーザで実行すること。
sudoコマンドなどでrootユーザから実行すると仮想環境の中にパッケージがインストールされない。
```
$ pip install --upgrade pip
$ pip install numpy
```
#### 4. 仮想環境の無効化
```
$ deactivate
```
