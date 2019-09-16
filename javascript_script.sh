#!/bin/bash

echo_statement() {
  echo ""
  echo -e "\033[0;35m ========== ${1} =========== \033[0m"
}

install_node() {
  echo_statement "Setting up node environment"
  curl -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh
  sudo bash nodesource_setup.sh 
  sudo apt-get install -y nodejs
}

clone_github_repo() {
  echo_statement "Cloning github repository"
  if [[ -d Politico-React ]]; then
    sudo rm -rf Politico-React
  fi
  sudo chown -R $(whoami) .config
  git clone ${GitHub_Repo}
}

install_dependencies() {
  echo_statement "Installing project dependencies"
  cd Politico-React
  sudo npm install node-pre-gyp -ES --unsafe-perm=true
  sudo npm i -ES --unsafe-perm=true
}

config_server="
  server  {
    server_name politico-api.tk www.politico-api.tk;
    location / {
      proxy_pass http://127.0.0.1:8080;
    }
  }
"

configure_NGINX() {
  echo_statement "Configuring NGINX reverse proxy server"
  sudo apt-get install nginx-full -y

  #  check if nginex folders already exists and remove them
  sudo rm -r /etc/nginx/sites-enabled/default
  if [[ -d /etc/nginx/sites-available/politico-react ]]; then
    sudo rm -rf /etc/nginx/sites-available/politico-react
  fi
   if [[ -d /etc/nginx/sites-enabled/politico-react ]]; then
    sudo rm -rf /etc/nginx/sites-available/politico-react
  fi

  sudo chown -R $(whoami) .config
  git clone ${GitHub_Repo}
  sudo echo ${config_server} > chmod +x /etc/nginx/sites-available/politico-react
  sudo ln -s /etc/nginx/sites-available/politico-react /etc/nginx/sites-enabled/politico-react
  sudo service nginx start
}

# npm audit fix
configure_SSL() {
  echo_statement "Configuring SSL Certificate"
  sudo apt-get update
  sudo apt-get install software-properties-common -y
  sudo npm update
  sudo add-apt-repository ppa:certbot/certbot -y
  sudo apt-get install certbot python-certbot-nginx -y
  sudo certbot --nginx  -d www.react-app-test.tk -d react-app-test.tk -m vic3coorp@gmail.com --agree-tos --non-interactive
}

start_script='
  {
    "apps": [
      {
        "name": "authors-haven",
        "script": "npm",
        "args": "run start:dev"
      }
    ]
  }
'

keep_App_Alive() {
  echo_statement "Install PM2 to run app in background"
  sudo npm install pm2 -g
  sudo echo ${start_script} > ./start_script.config.json
  pm2 start start_script.config.json
}

main() {
  install_node
  clone_github_repo
  install_dependencies
  configure_NGINX
  configure_SSL
  keep_App_Alive
}

main
