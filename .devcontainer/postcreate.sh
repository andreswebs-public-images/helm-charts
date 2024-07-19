#!/bin/bash

# Commands to run after the Container is created

## powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
cp ./.devcontainer/.p10k.zsh "$HOME/"
sed -i 's/^ZSH_THEME=.*/ZSH_THEME=\"powerlevel10k\/powerlevel10k\"/g' "$HOME/.zshrc"
echo "[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh" >> "$HOME/.zshrc"

# tool prep
CPU_ARCH=$(dpkg --print-architecture)
mkdir -p "$HOME/.local/bin"
KUBECONFORM="v0.6.4"
KUBESCORE="v1.18.0"

# kubeconform
wget -qO /tmp/kubeconform.tar.gz https://github.com/yannh/kubeconform/releases/download/"$KUBECONFORM"/kubeconform-linux-"$CPU_ARCH".tar.gz
cd /tmp && tar xvf kubeconform.tar.gz
mv /tmp/kubeconform "$HOME/.local/bin/"
chmod +x "$HOME/.local/bin/kubeconform"

## kube-score
wget -qO "$HOME/.local/bin/kube-score" https://github.com/zegl/kube-score/releases/download/"$KUBESCORE"/kube-score_1.18.0_linux_"$CPU_ARCH"
chmod +x "$HOME/.local/bin/kube-score"
