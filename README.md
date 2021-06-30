我的 VIM 配置.

#### 安装
```
git clone https://github.com/fcying/dotvim.git ~/.vim
```

#### 快捷键
默认 `<leader>` 是空格. 

使用 `vim-which-key`导航, 注册了`<space>`, `f`, `t`3个按键. 

#### 配置
在 `~/.vimrc.local` 可以修改一些本地配置, 使用`<leader>evl`修改.

项目配置保存在对应的`.git/.pvimrc`, 如果没有`scm`文件夹, 保存在工作目录下,使用`<leader>ep`修改.

补全框架默认用`coc`, 可以修改`g:complete_engine`更改.
