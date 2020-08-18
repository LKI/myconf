# enable vi mode
set -o vi

# general aliases
alias ..="cd .."
alias bv="bumpversion"
alias cnpm="npm --registry=https://registry.npm.taobao.org --cache=${HOME}/.npm/.cache/cnpm --disturl=https://npm.taobao.org/dist --userconfig=${HOME}/.cnpmrc"
alias conf="vim ~/.profile"
alias la="/bin/ls -ah"
alias ll="/bin/ls -lh"
alias ls="/bin/ls"
alias reload="source ~/.profile"
alias sk="skaffold"
alias sp="scoop"
alias st="stern --tail 200"
alias ta="tmux attach"
alias vi="vim"
alias ws='cd $(find $CODE -maxdepth 5 -type d -name ".git" | sed s/\.git$// | fzf)'
alias wsg="cd '$CODE'/github.com"
alias wsp="cd '$CODE'/pasta.zaihui.com.cn"
update () {
  scoop update '*'
  scoop cleanup '*'
  git -C ~/.vim pull
  git -C ~/.lki pull
}

# brew aliases
alias bc="brew cask"
alias bi="brew install"

# zeus aliases
alias z="docker exec -i -t zeus zeus"

# git aliases
alias g="git"
alias gc="git remote show | xargs -I{} git remote prune {} && git gc"
alias it="git"
alias lg="git logg"
alias lgs="git logs"
alias qgit="git"

# go aliases
alias gmt="go mod tidy"
alias gfm="go fmt"
gguv() { go get -u -v github.com/$1; }

# python/pip/pipenv aliases
alias pi="python -m pip"
alias pii="python -m pip install"
alias piiu="python -m pip install -U"
alias pilo="python -m pip list --outdated"
alias pip="python -m pip"
alias pm="python manage.py"
alias ppm="pipenv run python manage.py"
alias pr="pipenv run"
alias psi="python setup.py install"
alias pv="pipenv"
alias pvsd="pipenv sync --dev"
alias pvud="pipenv update --dev && pipenv clean"

alias jsonify="python -mjson.tool"

# make aliases
alias m="make"
alias mb="make build"
alias mt="make test"

# docker aliases from tcnksm/docker-alias
alias d="docker"
alias dc="docker-compose"
alias dex="docker exec -i -t"
alias di="docker images"
alias dip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"
alias dkd="docker run -d -P"
alias dki="docker run -i -t -P --rm"
alias dl="docker ps -l -q"
alias dpa="docker ps -a"
alias dps="docker ps"
alias drminone="docker images | grep none | tr -s ' ' | cut -d' ' -f3 | xargs -I{} docker rmi {}"
alias dspf="docker system prune -f"
dalias() { alias | grep 'docker' | sed "s/^\([^=]*\)=\(.*\)/\1 => \2/"| sed "s/['|\']//g" | sort; }
dbash() { docker exec -it $(docker ps -aqf "name=$1") bash; }
dbu() { docker build -t=$1 .; }
dkiv() { MSYS_NO_PATHCONV=1 dki -v $(pwd):/app --workdir /app $@; }
dri() { docker rmi $(docker images -q); }
drm() { docker rm $1; }
drmf() { docker stop $1; docker rm $1; }
dspm() { dsr python -W ignore::RuntimeWarning home/zaihui/server/ygg/manage.py $@; }
dsr() { dki -v d:/Code/pasta.zaihui.com.cn/zaihui/server:/home/zaihui/server:ro docker-inter.zaihui.com.cn/zaihui/server/base:latest $@; }
dst() { dspm test --failfast $@; }
dstop() { docker stop $(docker ps -a -q); }

alias ts="dki soimort/translate-shell"
alias tz="ts :zh"

# kubectl aliases
alias k="kubectl"
alias kaf="kubectl apply -f"
alias kak="kubectl apply -k"
alias kc="kubectl config"
alias kd="kubectl describe"
alias kdel="kubectl delete"
alias ke="kubectl edit"
alias kex="kubectl exec -it"
alias kg="kubectl get"
alias kga="kubectl get all"
alias kgns="kubectl get ns"
alias kgp="kubectl get pods -o wide"
alias kl="kubectl logs --tail=100 -f"
alias km="kustomize"
alias kp="kapp"
alias kr="kubectl rollout"
alias krr="kubectl rollout restart"
alias krs="kubectl rollout status"
alias kt="kubectl top"
kpm() { kex `kpo $1` -- python manage.py shell; }
kpvm() { kex `kpo $1` -- pipenv run python manage.py shell; }
kpo() { kg po | grep $1 | head -n1 | cut -d" " -f1; }
ksh() { kex `kpo $1` -- sh; }
kbash() { kex `kpo $1` -- bash; }
kcl() {
  CONTEXT=${1}
  if [[ -z "${CONTEXT}" ]]; then
    CURRENT=`kc current-context`
    CONTEXT=$(kc get-contexts -o=name | fzf --height=20 --preview='kubectl config use-context {} && kubectl get ns' --preview-window=:75%)
    CONTEXT=${CONTEXT:-${CURRENT}}
  fi
  kubectl config use-context ${CONTEXT} > /dev/null
}
kns() {
  NAMESPACE=${1}
  if [[ -z "${NAMESPACE}" ]]; then
    NAMESPACE=$(kg ns -o=name | sed 's/namespace\///' | fzf --height=50% --preview='kubectl get all -n {}' --preview-window=:70%)
  fi
  if [[ ! -z "${NAMESPACE}" ]]; then
    kubectl config set-context --current --namespace ${NAMESPACE} > /dev/null
  fi
}

# --- --- --- #

# set path
export PIPENV_VERBOSITY=-1
export BASH_SILENCE_DEPRECATION_WARNING=1
export EDITOR=vim
export LANG=en_US.UTF-8
export PATH=/c/codeenv/git/usr/bin:~/.lki/scripts:${PATH}
export DOCKER_REGISTRY=docker-inter.zaihui.com.cn
export KUBECONFIG=~/.kube/config

# ssh aliases
alias gethost='cat ~/.ssh/*_config | grep -e "^Host" | grep --color'
alias stp='kcl stp && kns forseti-sun && kex `kg po | grep worker | head -n1 | cut -d" " -f1` pipenv run python manage.py shell'
alias stt='kcl stt && kns forseti-sun && kex `kg po | grep worker | head -n1 | cut -d" " -f1` pipenv run python manage.py shell'
alias svp='kcl ddp && kcns zaihui-main && kex `kpo prod-celerybeat-` python manage.py shell'
gsh() {
  HOSTNAME=${1}
  if [[ -z "${HOSTNAME}" ]]; then
    HOSTNAME=$(cat ~/.ssh/*config  | grep ^Host | sed 's/^.....//' | fzf --height=20 | awk -F' ' '{print $1}')
  fi
  if [[ ! -z "{HOSTNAME}" ]]; then
    ssh -t ${HOSTNAME} "${@:2}"
  fi
}

# auto aliases  TODO: optimize speed
mkdir -p ~/.bash_aliases
python ~/.lki/scripts/git-to-bash.py > ~/.bash_aliases/git_aliases
source ~/.bash_aliases/*_aliases

if command -v starship &> /dev/null;
then
  eval "$(starship init bash)"
fi

if command -v pyenv &> /dev/null;
then
  eval "$(pyenv init -)"
fi
